//
//  ListOfParticipantsRepository.swift
//  qddapp
//
//  Created by gabatx on 24/4/23.
//

import Foundation
import Combine

protocol ListOfParticipantsRepositoryProtocol {
    func getParticipants(id: Int) async -> [UserModel]?
}

class ListOfParticipantsRepositoryApiRest  {

    var cancelable: Set<AnyCancellable> = []
    var requestManager: NetworkManager = NetworkManager(urlBase: "")
}

extension ListOfParticipantsRepositoryApiRest: ListOfParticipantsRepositoryProtocol {
    func getParticipants(id: Int) async -> [UserModel]? {
        return []
    }
}

class ListOfParticipantsRepositoryMock: ListOfParticipantsRepositoryProtocol {

    var requestManager = JsonManager()

    func getParticipants(id: Int) async -> [UserModel]? {
        let json = "Usuarios"
        let participants: [UserModel] = requestManager.get(json: json) ?? []
        return participants
    }
}
