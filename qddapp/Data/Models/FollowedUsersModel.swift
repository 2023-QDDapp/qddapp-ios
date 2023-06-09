//
//  FollowedUsersModel.swift
//  qddapp
//
//  Created by gabatx on 31/5/23.
//

import Foundation

struct FollowedUser: Codable, Identifiable {
    let id: Int
    let name: String
    let photo: String

    enum CodingKeys: String, CodingKey {
        case id
        case name = "nombre"
        case photo = "foto"
    }
}
