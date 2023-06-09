//
//  MapFilterView.swift
//  qddapp
//
//  Created by gabatx on 8/5/23.
//

import SwiftUI
import MapKit

struct MapFilterView: View {

    @EnvironmentObject var searchEventFilterViewModel: SearchEventFilterViewModel
    @EnvironmentObject var mapFilterViewModel: MapFilterViewModel
    @StateObject var locationManager: LocationManager = .init()
    @Binding var isActiveNavigationToMapFilterView: Bool
    @Binding var distanceCounter: Float
    @State var isEditingSlider = false
    @State var isEditingTextField = false
    @State var showAlertBasic = false

    var hasDistance: Bool = true

    init(isActiveNavigationToMapFilterView: Binding<Bool>, distanceCounter: Binding<Float>, hasDistance: Bool = true){
        self._isActiveNavigationToMapFilterView = isActiveNavigationToMapFilterView
        self._distanceCounter = distanceCounter
        self.hasDistance = hasDistance
    }

    var body: some View {
        VStack(spacing: 0){
            HStack (spacing: 0) {

                if !isEditingTextField {
                    Button {
                        mapFilterViewModel.pickedLocation = mapFilterViewModel.pickedLocationBackup
                        isActiveNavigationToMapFilterView = false
                    } label: {
                        Image(systemName: "arrow.left")
                            .renderingMode(.template) // IMPORTANTE: Colocar antes de .resizable
                            .resizable() // Le dice que ocupe todo el tamaño que pueda
                            .scaledToFit() // La imagen se ajusta al ancho
                            .frame(height: 18)
                            .foregroundColor(Color(LocalizedColor.textDark))
                            .padding(.trailing)
                    }
                }

                Spacer()

                HStack{
                    TextFieldBasicView(placerHolder: "¿Donde buscar?", inputText: $locationManager.searchText, colorButtonClean: Color(LocalizedColor.primary))
                        .onTapGesture {
                            isEditingTextField = true
                        }
                        .onSubmit(of: .search) {
                            isEditingTextField = false
                        }

                }
                .overlay(
                    withAnimation(){
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color(LocalizedColor.primary), lineWidth: isEditingTextField ? 2 : 0)
                    }
                )

                if isEditingTextField {
                    Button {
                        locationManager.searchText = ""
                        isEditingTextField = false
                        self.hideKeyboard()
                    } label: {
                        Text("Cancelar")
                            .modifier(body1(color: Color(LocalizedColor.primary)))
                            .padding(.leading)
                    }
                }
            }
            .padding(Constants.paddinGeneral)

            if isEditingTextField {
                ZStack{
                    Rectangle()
                        .foregroundColor(.white)
                    if let places = locationManager.fetchedPlaces,!places.isEmpty{

                        List{
                            ForEach(places,id: \.self){place in
                                Button {

                                    locationManager.removePin()
                                    if let coordinate = place.location?.coordinate{
                                        locationManager.pickedLocation = .init(latitude: coordinate.latitude, longitude: coordinate.longitude)
                                        locationManager.mapView.region = .init(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                                        locationManager.addDraggablePin(coordinate: coordinate)
                                        locationManager.updatePlacemark(location: .init(latitude: coordinate.latitude, longitude: coordinate.longitude))
                                        self.hideKeyboard()
                                    }
                                    isEditingTextField = false
                                    locationManager.searchText = place.name ?? ""

                                } label: {
                                    HStack(spacing: 15){
                                        Image(systemName: "mappin.circle.fill")
                                            .font(.title2)
                                            .foregroundColor(.gray)

                                        VStack(alignment: .leading, spacing: 6) {
                                            Text(place.name ?? "")
                                                .font(.title3.bold())
                                                .foregroundColor(.primary)

                                            Text(place.locality ?? "")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                Spacer()
                
            } else {
                VStack{
                    ZStack(alignment: .top){
                        MapView()
                            .environmentObject(locationManager)
                        HStack{
                            Button {
                                if locationManager.checkUserAutorization() {
                                    addPinInCurrentLocation()
                                } else {
                                    showAlertBasic = true
                                }
                            } label: {
                                Image(LocalizedImage.currentLocation)
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: 45, height: 45)
                                    .padding(.horizontal, 3)
                                    .padding(.top, 6)
                                    .padding(.bottom, -3)
                                    .scaledToFit()
                                    .foregroundColor(Color(LocalizedColor.textDark))
                                    .background(.white)
                                    .cornerRadius(10)
                            }
                            .buttonStyle(.plain)
                            .padding()
                            Spacer()
                        }
                    }

                    if hasDistance {
                        VStack(spacing: 0){
                            let limit: Float = 200
                            Slider(value: $distanceCounter,
                                   in: 0...limit,
                                   step: 10,
                                   onEditingChanged: { (editing) in
                                isEditingSlider = editing

                                mapFilterViewModel.spanBackup = locationManager.convertSliderValueToSpan(sliderValue: distanceCounter)

                                locationManager.updateCurrentDelta(sliderValue: distanceCounter,
                                                                   pickedLocation: mapFilterViewModel.pickedLocation, span: mapFilterViewModel.spanBackup!)
                            },
                                   label: {
                            })
                            .padding()
                            .accentColor(Color(LocalizedColor.primary))

                            HStack{
                                Text(distanceCounter == limit ? "Sin límites" : "Hasta \(distanceCounter.format()) km de mi")
                                    .foregroundColor(Color(LocalizedColor.textDark))
                                Spacer()
                            }
                            .padding(.horizontal, Constants.paddinGeneral)

                        }
                        .frame(height: 80)
                    }

                    Button {
                        isActiveNavigationToMapFilterView = false
                    } label: {
                        Text("Añadir")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(LocalizedColor.secondary))
                    }
                    .cornerRadius(10)
                    .padding(Constants.paddinGeneral)
                    .modifier(h5(color: .white))
                }
            }
        }
        .onAppear() {
            mapFilterViewModel.pickedLocationBackup = mapFilterViewModel.pickedLocation
            // Si el usuario aún no ha buscado una ubicación, pide obtener su ubicación actual
            if !mapFilterViewModel.userHasLocation {
                locationManager.getCurrentLocation()
                // Si ha aceptado permisos de ubicación
                if locationManager.checkUserAutorization() {
                    mapFilterViewModel.userHasLocation = true
                    return
                }
                addDefaultPin()
                return
            }
            // Si el usuario ya ha buscado una ubicación, se muestra en el mapa
            addExistingPin()
        }
        .onDisappear(){
            locationManager.searchText = ""
        }
        .onChange(of: locationManager.userHasLocation , perform: { newValue in
            mapFilterViewModel.userHasLocation = newValue
        })
        .onChange(of: locationManager.pickedLocation) { value in
            mapFilterViewModel.pickedLocation = value
        }
        .onChange(of: locationManager.pickedPlaceMark) { value in
            mapFilterViewModel.pickedPlaceMark = value
        }
        .onChange(of: locationManager.userLocation) { value in
            mapFilterViewModel.userLocation = value
        }
        .alert(isPresented: $showAlertBasic) {
            Alert(
                title: Text("Sin permisos de localización"),
                message: Text("¿Desea activarlos?"),
                primaryButton: .default(Text("Aceptar"), action: {
                    // Abre la configuración de la app
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }),
                secondaryButton: .destructive(Text("Cancelar")))
        }
    }

    func addExistingPin() {
        // Borrar el pin anterior
        locationManager.removePin()

        if let coordinate = mapFilterViewModel.pickedLocation?.coordinate{
            locationManager.addDraggablePin(coordinate: coordinate)
            locationManager.updatePlacemark(location: .init(latitude: coordinate.latitude, longitude: coordinate.longitude))
            locationManager.centerUserLocation()
            locationManager.updateCurrentDelta(sliderValue: distanceCounter,
                                               pickedLocation: mapFilterViewModel.pickedLocation, span: mapFilterViewModel.spanBackup ?? locationManager.regionDefault.span)
            return
        }
        addDefaultPin()
    }

    func addDefaultPin(){
        // Borrar el pin anterior
        locationManager.removePin()
        
        if let coordinate = Optional.some(locationManager.regionDefault.center) {
            locationManager.addDraggablePin(coordinate: coordinate)
            locationManager.updatePlacemark(location: .init(latitude: coordinate.latitude, longitude: coordinate.longitude))
            locationManager.centerUserLocation()
            locationManager.mapView.region = .init(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        }
    }

    func addPinInCurrentLocation(){
        // Borrar el pin anterior
        locationManager.removePin()

        if let coordinate = Optional.some(mapFilterViewModel.userLocation.center) {
            locationManager.addDraggablePin(coordinate: coordinate)
            locationManager.updatePlacemark(location: .init(latitude: coordinate.latitude, longitude: coordinate.longitude))
            locationManager.centerUserLocation()
            locationManager.updateRegion()
        }
    }
}

struct MapFilterView_Previews: PreviewProvider {
    static var previews: some View {
        MapFilterView(isActiveNavigationToMapFilterView: .constant(false), distanceCounter: .constant(200))
            .environmentObject(SearchEventFilterViewModel())
            .environmentObject(SearchEventByKeywordViewModel())
            .environmentObject(MapFilterViewModel())
            .environmentObject(LocationManager())
    }
}
