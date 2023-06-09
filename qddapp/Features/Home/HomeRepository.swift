//
//  HomeRepository.swift
//  qddapp
//
//  Created by gabatx on 23/4/23.
//

import Foundation

protocol HomeRepositoryProtocol {
    func getEventsForYou()  async  -> [EventListModel]
    func getEventsFollowedUsers() async -> [EventListModel]
}

// - MARK: Api
class HomeRepositoryApiRest {
    let requestManager: NetworkManager = NetworkManager(urlBase: Constants.urlBase)
}

extension HomeRepositoryApiRest: HomeRepositoryProtocol{

    func getEventsForYou() async  -> [EventListModel] {
        let endPoint = "users/\(Int(UserDefaultsManager.shared.userID!) ?? 0)/parati"
        do {
            return try await requestManager.get(endPoint: endPoint)
        } catch {
            print("Error en la obtención de datos: \(error)")
            return []
        }
    }

    func getEventsFollowedUsers() async -> [EventListModel]{
        let endPoint = "users/\(Int(UserDefaultsManager.shared.userID!) ?? 0)/pantallaseguidos"
        do {
            return try await requestManager.get(endPoint: endPoint)
        } catch {
            print("Error en la obtención de datos: \(error)")
            return []
        }
    }
}

// - MARK: Jsons
class HomeRepositoryMock: HomeRepositoryProtocol {

    let requestManager = JsonManager()

    func getEventsForYou() async  -> [EventListModel] {
        let json = "Eventos"
        return requestManager.get(json: json) ?? []
    }

    func getEventsFollowedUsers() async -> [EventListModel] { [] }
}

// - MARK: DataBase
class HomeRepositoryDataBase: HomeRepositoryProtocol {
    func getEventsForYou() async -> [EventListModel] { [] }
    func getEventsFollowedUsers() async -> [EventListModel] { [] }
}
