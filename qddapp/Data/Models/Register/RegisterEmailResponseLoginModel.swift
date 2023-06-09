//
//  RegisterEmailResponseLoginModel.swift
//  qddapp
//
//  Created by gabatx on 4/6/23.
//

import Foundation

struct RegisterEmailResponseLoginModel: Codable {
    let id: Int
    let message: String
    let email: String
    let password: String

    enum CodingKeys: String, CodingKey {
        case id
        case message = "mensaje"
        case email
        case password
    }
}
