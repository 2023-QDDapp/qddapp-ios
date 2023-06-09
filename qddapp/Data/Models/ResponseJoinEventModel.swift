//
//  ResponseJoinEventModel.swift
//  qddapp
//
//  Created by gabatx on 9/6/23.
//

import Foundation


enum ResponseJoinEvent: String, Codable {
    case joinEvent = "Te has unido al evento"
    case pendingResponse = "Pendiente de respuesta"
    case alreadyJoined = "Ya estás unido a este evento"
}

struct ResponseJoinEventModel: Codable {
    let message: ResponseJoinEvent

    enum CodingKeys: String, CodingKey {
        case message = "mensaje"
    }
}
