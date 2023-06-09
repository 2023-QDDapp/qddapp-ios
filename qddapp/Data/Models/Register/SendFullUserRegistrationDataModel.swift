//
//  SendFullUserRegistrationDataModel.swift
//  qddapp
//
//  Created by gabatx on 2/6/23.
//

import Foundation

struct SendFullUserRegistrationDataModel: Codable {
    let name: String
    let birthDate: String
    let phone: String
    let photo: String
    let biography: String
    let categories: [Int]

    enum CodingKeys: String, CodingKey {
        case name = "nombre"
        case birthDate = "fecha_nacimiento"
        case phone = "telefono"
        case photo = "foto"
        case biography = "biografia"
        case categories = "categorias"
    }
}
