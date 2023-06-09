//
//  DateExtension.swift
//  qddapp
//
//  Created by gabatx on 20/4/23.
//

import Foundation

extension Date {
    func toDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.locale = Locale(identifier: "es_ES")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.string(from: self)
    }

    func toTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.locale = Locale(identifier: "es_ES")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.string(from: self)
    }

    func toEventDetail() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d 'de' MMMM 'de' yyyy 'a las' HH:mm"
        dateFormatter.locale = Locale(identifier: "es_ES")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.string(from: self)
    }
    // Date a ISO8601.
    func formatDateToISO8601() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = Locale(identifier: "es_ES")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.string(from: self)
    }

    // 2023-04-14 09:30
    func formatDateTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.locale = Locale(identifier: "es_ES")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.string(from: self)
    }

    // 2023-04-14
    func formatDateToISO8601OnlyDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "es_ES")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.string(from: self)
    }

    // Devuelve el año actual
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }

    // Calcula el número de días dependiendo del mes y año
    func daysInMonth() -> Int {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: self)!
        return range.count
    }

    // Devuelve los meses del año String
    func monthsInYear() -> [String] {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "es_ES")
        return dateFormatter.monthSymbols
    }

    // Configura la fecha con el día
    func setDay(_ value: Date) -> Date {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: value)
        let month = calendar.component(.month, from: self)
        let year = calendar.component(.year, from: self)
        return calendar.date(from: DateComponents(year: year, month: month, day: day))!
    }

    func yearsInBetween() -> [Int] {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: Date()) - 18
        return Array(1900...year).reversed()
    }

    func isLeapYear(year: Int) -> Bool {
        return year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)
    }

}
