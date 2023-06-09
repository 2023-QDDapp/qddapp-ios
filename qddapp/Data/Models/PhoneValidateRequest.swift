//
//  PhoneValidateRequest.swift
//  qddapp
//
//  Created by gabatx on 1/6/23.
//

import Foundation

struct PhoneValidateRequest: Codable {
    let numberPhone : String

    enum CodingKeys: String, CodingKey {
        case numberPhone = "telefono"
    }
}
