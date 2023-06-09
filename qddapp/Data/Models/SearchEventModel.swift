//
//  SearchEventModel.swift
//  qddapp
//
//  Created by gabatx on 1/5/23.
//

import Foundation

struct SearchEventModel: Codable, Identifiable {
    var id: String
    var idUser: Int
    var date: String
    var search: String

    init(search: String){
        self.id = UUID().uuidString
        self.date = Date().toDate()
        self.idUser = OfflineDataManagerViewModel.idUser
        self.search = search
    }
}
