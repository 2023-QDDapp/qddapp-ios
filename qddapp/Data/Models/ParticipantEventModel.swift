//
//  ParticipantEventModel.swift
//  qddapp
//
//  Created by gabatx on 24/4/23.
//

import Foundation

struct ParticipantEventModel: Codable, Identifiable {
    let id: Int
    let name: String
    var photo: String
    let type: String?
    let age: Int?

     enum CodingKeys: String, CodingKey {
         case id
         case name = "nombre"
         case photo = "foto"
         case type
         case age

     }
 }
