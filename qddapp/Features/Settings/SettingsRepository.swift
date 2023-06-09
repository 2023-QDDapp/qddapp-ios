//
//  SettingsRepository.swift
//  qddapp
//
//  Created by gabatx on 4/6/23.
//

import Foundation

protocol SettingsRepositoryProtocol {
    func deleleUserAccount(idUser: String, token: String) async -> MessageResponseModel
}

class SettingsRepositoryApiRest {
    let requestManager: NetworkManager = NetworkManager(urlBase: Constants.urlBase)
}

extension SettingsRepositoryApiRest:SettingsRepositoryProtocol {

    func deleleUserAccount(idUser: String, token: String) async -> MessageResponseModel {
        let endPoint = "users/\(idUser)"
        return try! await requestManager.delete(endPoint: endPoint, token: token)
    }
}
