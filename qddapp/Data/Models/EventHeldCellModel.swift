//
//  EventHeldCellModel.swift
//  qddapp
//
//  Created by gabatx on 8/6/23.
//

import Foundation

struct EventHeldCellModel: Codable {

    let idEvent: Int
    let idOrganizer: Int
    let photo: String
    let titleEvent: String
    let dateStart: String

    enum CodingKeys: String, CodingKey {
        case idEvent = "id_evento"
        case idOrganizer = "id_organizador"
        case photo = "foto_organizador"
        case titleEvent = "titulo"
        case dateStart = "fecha_hora_inicio"
    }
}
