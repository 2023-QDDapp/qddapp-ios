//
//  PhoneValidateResponseModel.swift
//  qddapp
//
//  Created by gabatx on 1/6/23.
//

import Foundation

struct MessageResponseModel: Codable {

    let message: String

    enum CodingKeys: String, CodingKey {
        case message = "mensaje"
    }
}
