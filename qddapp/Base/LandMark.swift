//
//  LandMark.swift
//  qddapp
//
//  Created by gabatx on 20/4/23.
//

import Foundation
import MapKit

class Landmark: Identifiable {
    let name: String
    let coordinate: CLLocationCoordinate2D

    init(name: String, coordinate: CLLocationCoordinate2D) {
        self.name = name
        self.coordinate = coordinate
    }
}
