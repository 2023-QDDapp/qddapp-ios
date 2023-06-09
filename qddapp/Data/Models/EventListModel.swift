//
//  EventListModel.swift
//  qddapp
//
//  Created by Escuela de Tecnologias Aplicadas on 22/5/23.
//

import Foundation

struct EventListModel: Codable, Identifiable {
    let id: Int
    let idOrganiser: Int
    let nameOrganiser: String
    var photoOrganiser: String
    let age: Int
    var photoEvent: String
    let title: String
    let eventDescription: String?
    let dateStartTime: String
    let idCategory: Int?
    let category: String

    enum CodingKeys: String, CodingKey {
        case id = "id_evento"
        case idOrganiser = "id_organizador"
        case nameOrganiser = "organizador"
        case photoOrganiser = "foto_organizador"
        case age = "edad"
        case photoEvent = "imagen_evento"
        case title = "titulo"
        case eventDescription = "descripcion"
        case dateStartTime = "fecha_hora_inicio"
        case idCategory = "id_categoria"
        case category = "categoria"
    }
}
