//
//  SearchEventResultRepository.swift
//  qddapp
//
//  Created by gabatx on 5/6/23.
//

import Foundation

protocol SearchEventResultRepositoryProtocol {
    func sendDataSearch(data: String) async -> [EventListModel]
}

class SearchEventResultRepositoryApiRest {
    var requestManager: NetworkManager = NetworkManager(urlBase: Constants.urlBase)
}

extension SearchEventResultRepositoryApiRest: SearchEventResultRepositoryProtocol {

    func sendDataSearch(data: String) async -> [EventListModel] {
        let endPoint = "events/filter?\(data)"
        do {
            return try await requestManager.get(endPoint: endPoint)
        } catch {
            print("Error en la obtención de datos: \(error)")
            return []
        }
    }
}
