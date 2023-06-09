//
//  LoginModel.swift
//  qddapp
//
//  Created by gabatx on 1/6/23.
//

import Foundation

struct LoginResponseModel: Codable {
    let id: Int
    let token: String
    let isVerified: Int
    let isRegistered: Int

    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case token
        case isVerified = "is_verified"
        case isRegistered = "is_registered"
    }
}
