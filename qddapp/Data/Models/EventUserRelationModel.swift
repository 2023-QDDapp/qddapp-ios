//
//  EventUserRelationModel.swift
//  qddapp
//
//  Created by gabatx on 9/6/23.
//

import Foundation

struct RequestIdBodyModel: Codable {
    let id: Int
}

enum EventUserRelationModel: String, Codable {
    case organizer = "organizador"
    case accepted = "aceptado"
    case pending = "pendiente"
    case noRelation = "norelacion"
    case eventFinished
    case leaveReviewsAssistant
    case leaveReviewOrganizer
}

struct ResponseEventUserRelationModel: Codable {
    let relation : EventUserRelationModel

    enum CodingKeys: String, CodingKey {
        case relation = "relacion"
    }
}

