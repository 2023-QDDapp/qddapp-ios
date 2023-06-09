//
//  MapFilterViewModel.swift
//  qddapp
//
//  Created by gabatx on 8/5/23.
//

// pickedLocationBackup: Se utiliza para que en caso de que usuario entre al mapa, si cambia la ubicación del pin y decice salir sin darle a aceptar, que se mantenga la ubicación del pin anterior que tenía al entrar.

import Foundation
import CoreLocation
import MapKit

class MapFilterViewModel: ObservableObject {

    @Published var textSearchLocation = ""
    @Published var userHasLocation = false
    @Published var userLocation: MKCoordinateRegion = .init()
    @Published var pickedLocation: CLLocation?
    @Published var pickedLocationBackup: CLLocation?
    @Published var pickedPlaceMark: CLPlacemark?
    @Published var spanBackup: MKCoordinateSpan?
}
