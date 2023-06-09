//
//  LocationViewModel.swift
//  qddapp
//
//  Created by gabatx on 5/5/23.
//

import Foundation
import MapKit
import CoreLocation
import Combine

// IMPORTANTE: Añadir en info.plist el permiso -> Privacy - Location When In Use Usage Description
final class LocationManager: NSObject,ObservableObject {

    var regionDefault = MKCoordinateRegion(
        // El punto central del mapa
        center: CLLocationCoordinate2D(latitude: 40.416775, longitude: -3.703790),
        // Cuanto queremos que se vea del mapa. Se mide en grados
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))

    @Published var userLocation: MKCoordinateRegion = .init()
    @Published var userHasLocation: Bool = false

    var currentDelta: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    var circle: MKCircle!
    private let locationManager: CLLocationManager = .init()

    // ----- LOCATIONMANAGER

    // MARK: Propiedades
    @Published var mapView: MKMapView = .init()
    @Published var manager: CLLocationManager = .init()

    // MARK: Texto de la barra de búsqueda
    @Published var searchText: String = ""
    var cancellable: AnyCancellable?
    @Published var fetchedPlaces: [CLPlacemark]?

    // MARK: User Location / Ubicación del usuario
    //@Published var userLocation: CLLocation?

    // MARK: Final Location / Ubicación final
    // La información de latitud, longitud y rumbo comunicada por el sistema.
    @Published var pickedLocation: CLLocation?
    // Descripción sencilla de una coordenada geográfica, que suele contener el nombre del lugar, su dirección y otra información relevante.
    @Published var pickedPlaceMark: CLPlacemark?

    override init() {
        super.init()
        // MARK: Establecemos los delegados
        mapView.delegate = self
        manager.delegate = self
        // Asignamos el delegado de CLLocationManagerDelegate. Nos va a visar de cada actualización del usuario. Le decimos que se encargue LocationManager de recibir esta información.
        locationManager.delegate = self

        // Añadir gesto a mapView:
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        mapView.addGestureRecognizer(longPressGesture)

        // Localización por defecto para el caso de que no autorice los permisos de localización.
        userLocation = .init(center: .init(latitude: regionDefault.center.latitude, longitude: regionDefault.center.longitude), span: .init(latitudeDelta: regionDefault.span.latitudeDelta, longitudeDelta: regionDefault.span.longitudeDelta))

        // MARK: Observador para el texto introducido en el Textfield/Buscador
        cancellable = $searchText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink(receiveValue: { value in
                if value != ""{
                    self.fetchPlaces(value: value)
                }else{
                    self.fetchedPlaces = nil
                }
            })

        circle = MKCircle(center: CLLocationCoordinate2D(latitude: 37.786834, longitude: -122.406417), radius: 500)
    }

    func getCurrentLocation(){
        // Le estamos diciendo que sea la mejor localización
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // Que se pida la localización cuando la app esté en uso
        locationManager.requestWhenInUseAuthorization()
        // Empieza a recibir localizaciones de la localización del user
        locationManager.startUpdatingLocation()
    }

    // Método para saber que escoge el user cuando le aperece el alert de la autorización de la localización.
    @discardableResult
    func checkUserAutorization() -> Bool{
        let status = locationManager.authorizationStatus
        switch status {
        case .notDetermined, .restricted, .denied:
            return false
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        @unknown default:
            return true
        }
    }

    // MARK: Búsqueda de lugares con MKLocalSearch y Asyc/Await
    func fetchPlaces(value: String){
        Task{
            do{
                let request = MKLocalSearch.Request()
                request.naturalLanguageQuery = value.lowercased()

                let response = try await MKLocalSearch(request: request).start()
                // Podemos utilizar MainActor para publicar los cambios en el hilo principal
                await MainActor.run(body: {
                    self.fetchedPlaces = response.mapItems.compactMap({ item -> CLPlacemark? in
                        return item.placemark
                    })
                })
            }
            catch {
                // HANDLE ERROR
            }
        }
    }

    func centerUserLocation() {
        // MARK: Mostrar la localización del user
        // Le decimos que se centre en la localización del user
        mapView.setRegion(userLocation, animated: true)
    }

    func showUserLocationWithPointBlue(){
        // Le decimos que muestre la localización del user con el punto azul
        mapView.showsUserLocation = true
    }

    func removePin() {
        // MARK: Eliminar el pin
        // Eliminamos el pin
        mapView.removeAnnotations(mapView.annotations)
    }
}
// - Podemos recibir información del user, info de las autorizaciones o cualquier otro tema relacionado con la localización.
extension LocationManager: CLLocationManagerDelegate {
    // Esta función se invoca cuando hay nuevas ubicaciones disponibles
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        print("Location \(location)")

        userLocation = .init(center: location.coordinate , span: .init(latitudeDelta: regionDefault.span.longitudeDelta, longitudeDelta: regionDefault.span.longitudeDelta))

        pickedLocation = location
        mapView.region = .init(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        addDraggablePin(coordinate: pickedLocation!.coordinate)
        updatePlacemark(location: location)
        locationManager.stopUpdatingLocation()
        userHasLocation = true
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Manejamos el error si no se aceptan los permisos:
        print("El usuario no ha permitido los permisos de locacalización")
    }

    // Esta función se invoca cada vez que detectemos un cambio en la autorización de locationManager(permisos de localización asignados a la app).
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // Llamaremos a checkUserAutorization() para que valide los permisos
        checkUserAutorization()
    }
}

extension LocationManager: MKMapViewDelegate {

    // MARK: Añadir pin arrastrable a MapView
    func addDraggablePin(coordinate: CLLocationCoordinate2D){
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Tu evento será aquí"
        self.pickedLocation = .init(latitude: coordinate.latitude, longitude: coordinate.longitude)
        mapView.addAnnotation(annotation)
    }

    // MARK: Activar el arrastre
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        let marker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "DELIVERYPIN")
        marker.isDraggable = true
        marker.canShowCallout = false

        return marker
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        guard let newLocation = view.annotation?.coordinate else{return}
        self.pickedLocation = .init(latitude: newLocation.latitude, longitude: newLocation.longitude)
        updatePlacemark(location: .init(latitude: newLocation.latitude, longitude: newLocation.longitude))
        // Actualizamos la región del mapa al soltar el pin
        if newState == .ending {
            updateRegion()
        }
    }

    func updateRegion(){
        mapView.setRegion(MKCoordinateRegion(center: .init(latitude: (pickedLocation?.coordinate.latitude)!, longitude: (pickedLocation?.coordinate.longitude)!), span: currentDelta), animated: true)
    }

    func updatePlacemark(location: CLLocation){
        Task{
            do{
                guard let place = try await reverseLocationCoordinates(location: location) else {return}
                await MainActor.run(body: {
                    self.pickedPlaceMark = place
                })
            }
            catch{
                // HANDLE ERROR
            }
        }
    }

    // MARK: Visualización de nuevos datos de localización
    func reverseLocationCoordinates(location: CLLocation)async throws->CLPlacemark?{
        let place = try await CLGeocoder().reverseGeocodeLocation(location).first
        return place
    }

    // MARK: Detecta el zoom realizado en el mapa
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        currentDelta = .init(latitudeDelta: mapView.region.span.latitudeDelta, longitudeDelta: mapView.region.span.longitudeDelta)
    }

    // MARK: Detecta una pulsación larga en el mapa. Añade un pin en la localización pulsada.
    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state != .began { return }

        let touchPoint = gestureRecognizer.location(in: mapView)
        let touchMapCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)

        let annotation = MKPointAnnotation()
        annotation.coordinate = touchMapCoordinate
        annotation.title = "Tu evento será aquí"

        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(annotation)
        pickedLocation = .init(latitude: touchMapCoordinate.latitude, longitude: touchMapCoordinate.longitude)
        updatePlacemark(location: .init(latitude: touchMapCoordinate.latitude, longitude: touchMapCoordinate.longitude))
        mapView.setRegion(MKCoordinateRegion(center: .init(latitude: touchMapCoordinate.latitude, longitude: touchMapCoordinate.longitude), span: currentDelta), animated: true)
    }

    // Función que actualiza la distancia a la que se muestra el pin en el mapa (currentDelta)
    func convertSliderValueToSpan(sliderValue: Float) -> MKCoordinateSpan {
        let maximumRange = 12.0
        let minimumRange = 0.001
        let deltaRange = maximumRange - minimumRange
        let delta = Double(sliderValue) / 200.0 * deltaRange + minimumRange

        let span:MKCoordinateSpan = .init(latitudeDelta: delta, longitudeDelta: delta)
        return span
    }

    func updateCurrentDelta(sliderValue: Float, pickedLocation: CLLocation?, span: MKCoordinateSpan) {

        mapView.setRegion(MKCoordinateRegion(center: .init(latitude: (pickedLocation?.coordinate.latitude)!, longitude: (pickedLocation?.coordinate.longitude)!), span: span), animated: true)
    }
}
