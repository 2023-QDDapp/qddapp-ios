//
//  EventCreateModel.swift
//  qddapp
//
//  Created by gabatx on 19/5/23.
//

import Foundation


struct EventCreateModel: Codable {
    var id: Int
    var categorySelected: Int
    var tittleEvent: String
    var currentDateStart: String
    var currentDateEnd: String
    var descriptionEvent: String
    var imageEvent: String
    /// Añade el tipo de evento con 0 o 1.
    ///
    /// - Parameters:
    ///   - 0: Privado.
    ///   - 1: Público.
    var typeEvent: Int
    var locationName: String
    var eventLatitude: String
    var eventLongitude: String

    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case categorySelected = "categoria_id"
        case tittleEvent = "titulo"
        case currentDateStart = "fecha_hora_inicio"
        case currentDateEnd = "fecha_hora_fin"
        case descriptionEvent = "descripcion"
        case imageEvent = "imagen"
        case typeEvent = "tipo"
        case locationName = "location"
        case eventLatitude = "latitud"
        case eventLongitude = "longitud"
    }
}
