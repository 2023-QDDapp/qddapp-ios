//
//  UserModel.swift
//  qddapp
//
//  Created by gabatx on 16/4/23.
//

import Foundation

struct UserModel: Codable, Identifiable, Equatable {

    static func ==(lhs: UserModel, rhs: UserModel) -> Bool {
        return lhs.id == rhs.id
    }
    let id: Int
    let name: String
    let photo: String
    let phone: String
    let age: Int
    let description: String
    let interests: [CategoryModel]
    let ratings: [RatingModel]

    enum CodingKeys: String, CodingKey {
        case id
        case name = "nombre"
        case photo = "foto"
        case phone = "telefono"
        case age = "edad"
        case description = "biografia"
        case interests = "intereses"
        case ratings = "valoraciones"
    }
}

struct RatingModel: Codable, Hashable {
    let idUser: Int
    let date: String?
    let name: String
    let photo: String
    let rating: Double?
    let message: String

    enum CodingKeys: String, CodingKey {
        case idUser = "id_usuario"
        case date
        case name = "nombre_usuario"
        case photo = "foto"
        case rating = "valoracion"
        case message = "mensaje"
    }
}
