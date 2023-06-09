//
//  MapSwiftUIView.swift
//  qddapp
//
//  Created by gabatx on 14/5/23.
//

import SwiftUI
import CoreLocation
import MapKit

struct MapSwiftUIView: View {

    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var mapFilterViewModel: MapFilterViewModel

    // ViewModel de la vista que lo albergue
    @Binding var isActiveNavigationToMapFilterView: Bool
    @Binding var distanceCounter: Float
    var hasDistance: Bool

    init(isActiveNavigationToMapFilterView: Binding<Bool>, distanceCounter: Binding<Float>, hasDistance: Bool) {
        self._isActiveNavigationToMapFilterView = isActiveNavigationToMapFilterView
        self._distanceCounter = distanceCounter
        self.hasDistance = hasDistance
    }

    var body: some View {

        Button {
            isActiveNavigationToMapFilterView = true
        } label: {
            VStack(alignment: .center, spacing: 0) {
                HStack{
                    Text("Ubicación:")
                        .modifier(body1())

                    let locality = mapFilterViewModel.pickedPlaceMark?.locality ?? ""
                    //let thoroughfare = mapFilterViewModel.pickedPlaceMark?.thoroughfare ?? ""
                    //let subThoroughfare = mapFilterViewModel.pickedPlaceMark?.subThoroughfare ?? ""
                    //Text("\(locality), \(thoroughfare), \(subThoroughfare)")
                    Text("\(locality)")
                        .modifier(body1())
                    Spacer()
                    if mapFilterViewModel.pickedPlaceMark != nil {
                        Button {
                            mapFilterViewModel.pickedLocation = nil
                            mapFilterViewModel.pickedPlaceMark = nil
                        } label: {
                            ButtonClean(color: Color(LocalizedColor.grayIconTextField))
                        }
                    }
                }
                .padding(.vertical)
                // Añadimos el mapa
                ZStack(alignment: .top) {
                    let region = MKCoordinateRegion(
                        // El punto central del mapa
                        center: mapFilterViewModel.pickedLocation?.coordinate ?? CLLocationCoordinate2D(latitude: locationManager.regionDefault.center.latitude, longitude: locationManager.regionDefault.center.longitude),
                        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))

                    Map(
                        coordinateRegion: .constant(region),
                        showsUserLocation: false, annotationItems: [
                            Landmark(name: mapFilterViewModel.pickedPlaceMark?.locality ?? "Madrid", coordinate: region.center)
                        ]) { landmark in

                            MapAnnotation(coordinate: landmark.coordinate) {
                                if mapFilterViewModel.pickedPlaceMark != nil {
                                    Image(systemName: "mappin.circle.fill")
                                        .foregroundColor(.red)
                                        .background(.white)
                                        .cornerRadius(50)
                                        .font(.system(size: 20))
                                        .shadow(radius: 1)
                                }
                            }
                        }
                        .frame(height: 150)
                        .cornerRadius(10)
                }
                if hasDistance {
                    HStack{
                        Text("Distancia:")
                            .modifier(body1())
                        Text(distanceCounter == 200 ? "Sin límites" : "\("Hasta \(distanceCounter.format()) km de mi")")
                            .modifier(body1())
                        Spacer()
                    }
                    .padding(.vertical)
                }
            }
        }
        .fullScreenCover(
            // Aquí le decimos que cuando el booleano isPresented sea true, se muestre la vista.
            isPresented: $isActiveNavigationToMapFilterView,
            // Cuando se cierre la vista, se ejecuta la acción que le hemos indicado.
            onDismiss: { },
            // Aquí le decimos que contenido queremos que muestre la vista.
            content: {
                MapFilterView(isActiveNavigationToMapFilterView: $isActiveNavigationToMapFilterView, distanceCounter: $distanceCounter, hasDistance: hasDistance)
            })
    }
}

struct MapSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        MapSwiftUIView(isActiveNavigationToMapFilterView: .constant(false), distanceCounter: .constant(200), hasDistance: false)
            .environmentObject(LocationManager())
            .environmentObject(MapFilterViewModel())
    }
}
