//
//  StringExtension.swift
//  qddapp
//
//  Created by gabatx on 20/4/23.
//

import Foundation
import SwiftUI

extension String {
    // Convertir un string a Date: 2023-04-14 09:30:00
    func stringToDate(withFormat format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "es_ES")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.date(from: self)
    }
    // Convierte un string a una fecha formateada. Ej: 6 de abril de 2023 a las 16:00
    func stringToFormatterDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "es_ES")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let date = dateFormatter.date(from: self)

        dateFormatter.dateFormat = "d 'de' MMMM 'de' yyyy 'a las' HH:mm"
        dateFormatter.locale = Locale(identifier: "es_ES")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.string(from: date ?? Date())
    }
    // Prepara el string para ser enviado mediante una url
    func urlEncode() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
}
