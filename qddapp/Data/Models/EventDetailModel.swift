//
//  EventDetailModel.swift
//  qddapp
//
//  Created by Escuela de Tecnologias Aplicadas on 22/5/23.
//

import Foundation

struct EventDetailModel: Codable, Identifiable, Equatable {

    static func ==(lhs: EventDetailModel, rhs: EventDetailModel) -> Bool {
        return lhs.id == rhs.id 
    }

    var id: Int
    var tittleEvent: String
    var nameOrganiser: String
    var idOrganiser: Int
    var photoOrganiser: String
    var age: Int
    var description: String
    var photoEvent: String
    var typeEvent: Int
    var dateStart: String
    var dateEnd: String
    var locality: String
    var latitude: Double
    var longitude: Double
    var category: String
    var numPartipants: Int
    var participants: [ParticipantEventModel]

    enum CodingKeys: String, CodingKey {
        case id = "id_evento"
        case tittleEvent = "titulo"
        case nameOrganiser = "organizador"
        case idOrganiser = "id_organizador"
        case photoOrganiser = "foto_organizador"
        case age = "edad"
        case description = "descripcion"
        case photoEvent = "imagen_evento"
        case typeEvent = "tipo"
        case dateStart = "fecha_hora_inicio"
        case dateEnd = "fecha_hora_fin"
        case locality = "location"
        case latitude = "latitud"
        case longitude = "longitud"
        case category = "categoria"
        case numPartipants = "num_participantes"
        case participants = "asistentes"
    }
}
