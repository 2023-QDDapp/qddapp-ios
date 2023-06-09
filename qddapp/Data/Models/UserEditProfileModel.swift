//
//  UserEditProfileModel.swift
//  qddapp
//
//  Created by gabatx on 6/6/23.
//

import Foundation


struct UserEditProfileModel: Codable {
    var name: String
    var photo: String
    var phone : String?
    var biography: String
    var interests: [Int]

    enum CodingKeys: String, CodingKey {
        case name = "nombre"
        case photo = "foto"
        case phone = "telefono"
        case biography = "biografia"
        case interests = "categorias"
    }
}
