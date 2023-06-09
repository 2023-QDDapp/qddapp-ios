//
//  EventDetailRepository.swift
//  qddapp
//
//  Created by gabatx on 24/4/23.
//

import Foundation

protocol EventDetailRepositoryProtocol {
    func getEventById(id: Int) async -> EventDetailModel
    func getEventToUserRelationship(idEvent: RequestIdBodyModel) async throws -> EventUserRelationModel
    func assist(idEvent: RequestIdBodyModel) async -> MessageResponseModel
    func cancelEvent(idEvent: Int) async -> MessageResponseModel
    func requestToJoinTheEvent(idEvent: RequestIdBodyModel) async -> ResponseJoinEventModel
    func cancelAssistanceToEvent(idEvent: Int) async -> MessageResponseModel
}

// - MARK: Api
class EventDetailRepositoryApiRest {
    let requestManager: NetworkManager = NetworkManager(urlBase: Constants.urlBase)
}

extension EventDetailRepositoryApiRest: EventDetailRepositoryProtocol {
    func requestToJoinTheEvent(idEvent: RequestIdBodyModel) async -> ResponseJoinEventModel {
        let endPoint = "events/\(idEvent.id)/join"
        let token = UserDefaultsManager.shared.userToken!
        do {
            return try await requestManager.post(endPoint: endPoint, body: idEvent, token: token)
        } catch {
            print("Error en la obtención de datos: \(error)")
            return ResponseJoinEventModel(message: .alreadyJoined)
        }
    }

    func getEventToUserRelationship(idEvent: RequestIdBodyModel) async -> EventUserRelationModel {
        let endPoint = "events/\(idEvent.id)/relationUser"
        let token = UserDefaultsManager.shared.userToken!
        do {
            let response: ResponseEventUserRelationModel = try await requestManager.get(endPoint: endPoint, token: token)
            return EventUserRelationModel(rawValue: response.relation.rawValue) ?? .noRelation
        } catch {
            print("Error en la obtención de datos: \(error)")
            return .noRelation
        }
    }

    func getEventById(id: Int) async -> EventDetailModel {
        let endPoint = "events/\(id)"
        do {
            return try await requestManager.get(endPoint: endPoint)
        } catch {
            print("Error en la obtención de datos: \(error)")
            return DateFake.event
        }
    }

    // MARK: - Acciones del botón
    func assist(idEvent: RequestIdBodyModel) async -> MessageResponseModel {
        let endPoint = "events/\(idEvent.id)/join"
        let token = UserDefaultsManager.shared.userToken!
        do {
            return try await requestManager.post(endPoint: endPoint, body: idEvent, token: token)
        } catch {
            print("Error en la obtención de datos: \(error)")
            return DateFake.messageResponseModel
        }
    }

    func cancelEvent(idEvent: Int) async -> MessageResponseModel {
        let endPoint = "events/\(idEvent)"
        let token = UserDefaultsManager.shared.userToken!
        do {
            return try await requestManager.delete(endPoint: endPoint, token: token)
        } catch {
            print("Error en la obtención de datos: \(error)")
            return MessageResponseModel(message: "Error en la petición")
        }
    }

    func cancelAssistanceToEvent(idEvent: Int) async -> MessageResponseModel {
        let endPoint = "events/\(idEvent)/abandonar"
        let token = UserDefaultsManager.shared.userToken!
        do {
            return try await requestManager.post(endPoint: endPoint, body: RequestIdBodyModel(id: idEvent), token: token)
        } catch {
            print("Error en la obtención de datos: \(error)")
            return MessageResponseModel(message: "Error en la petición")
        }
    }
}


class EventDetailRepositoryMock: EventDetailRepositoryProtocol{
    func cancelAssistanceToEvent(idEvent: Int) async -> MessageResponseModel {
        MessageResponseModel(message: "")
    }

    func requestToJoinTheEvent(idEvent: RequestIdBodyModel) async -> ResponseJoinEventModel {
        ResponseJoinEventModel(message: .joinEvent)
    }

    func getEventToUserRelationship(idEvent: RequestIdBodyModel) async  -> EventUserRelationModel {
        .noRelation
    }

    func cancelEvent(idEvent: Int) async -> MessageResponseModel {
        MessageResponseModel(message: "")
    }

    func assist(idEvent: RequestIdBodyModel) async -> MessageResponseModel {
        MessageResponseModel(message: "")
    }




    let requestManager = JsonManager()

    func getEventById(id: Int) async -> EventDetailModel {
        let json = "EventsDetail"
        let events: [EventDetailModel] = requestManager.get(json: json) ?? []
        return  events.first { $0.id == id } ?? DateFake.event
    }
}
