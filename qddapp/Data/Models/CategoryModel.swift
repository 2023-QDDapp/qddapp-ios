//
//  CategoryModel.swift
//  qddapp
//
//  Created by gabatx on 8/5/23.
//

import Foundation

struct CategoryModel: Codable, Identifiable {
    
    var id: Int
    var name: String

    enum CodingKeys: String, CodingKey {
        case id
        case name = "categoria"
    }
}
