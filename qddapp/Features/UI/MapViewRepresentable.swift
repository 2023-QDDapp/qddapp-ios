//
//  MapViewRepresentable.swift
//  qddapp
//
//  Created by gabatx on 8/5/23.
//

import SwiftUI
import MapKit

// UIViewRepresentable: Nos deja envolver una vista de UIKit para que pueda ser utiliza en swiftUI.
struct MapView: UIViewRepresentable {
    typealias UIViewType = MKMapView
    @EnvironmentObject var locationManager: LocationManager

    func makeUIView(context: Context) -> MKMapView {
        return locationManager.mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {  }
}


struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
