//
//  EventsHeldRepository.swift
//  qddapp
//
//  Created by gabatx on 8/6/23.
//

import Foundation

protocol EventsHeldRepositoryProtocol {
    func getMyEvents(idUser: Int) async -> [EventHeldCellModel]
    func getEventsHeldHistory(idUser: Int) async -> [EventHeldCellModel]
}

class EventsHeldRepositoryApiRest {
    let requestManager: NetworkManager = NetworkManager(urlBase: Constants.urlBase)
}

extension EventsHeldRepositoryApiRest: EventsHeldRepositoryProtocol {
    func getMyEvents(idUser: Int) async -> [EventHeldCellModel]{
        let endPoint = "users/\(idUser)/events"
        do {
            return try await requestManager.get(endPoint: endPoint)
        } catch {
            print("Error en la obtención de datos: \(error)")
            return [DateFake.eventHeldCell]
        }
    }
    
    func getEventsHeldHistory(idUser: Int) async -> [EventHeldCellModel]{
        let endPoint = "users/\(idUser)/historial"
        do {
            return try await requestManager.get(endPoint: endPoint)
        } catch {
            print("Error en la obtención de datos: \(error)")
            return [DateFake.eventHeldCell]
        }
    }
}
