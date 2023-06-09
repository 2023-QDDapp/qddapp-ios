//
//  NumberExtension.swift
//  qddapp
//
//  Created by gabatx on 5/5/23.
//

import Foundation

extension Float {
    // Formatea un float a un string sin decimales
    func format() -> String {
        return String(format: "%.0f", self)
    }

    // Convierte Float eliminando los decimales
    func toInt() -> Int {
        return Int(self)
    }
}
