//
//  EventCreateRepository.swift
//  qddapp
//
//  Created by gabatx on 6/6/23.
//

import Foundation

protocol EventCreateRepositoryProtocol {
    func requestToCreateEvent(data: EventCreateModel) async -> MessageResponseModel
}

class EventCreateRepositoryApiRest {
    let requestManager: NetworkManager = NetworkManager(urlBase: Constants.urlBase)
}

extension EventCreateRepositoryApiRest: EventCreateRepositoryProtocol {
    
    func requestToCreateEvent(data: EventCreateModel) async -> MessageResponseModel {
        let endPoint = "events"
        do {
            return try await requestManager.post(endPoint: endPoint, body: data, token: UserDefaultsManager.shared.userToken!)
        } catch {
            print("Error en la obtención de datos: \(error)")
            return DateFake.messageResponseModel
        }
    }
}
