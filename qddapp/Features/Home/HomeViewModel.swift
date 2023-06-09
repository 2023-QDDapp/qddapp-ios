//
//  HomeViewModel.swift
//  qddapp
//
//  Created by gabatx on 23/4/23.
//

import Foundation

@MainActor
class HomeViewModel: ObservableObject {

    var repository: HomeRepositoryProtocol = HomeRepositoryApiRest()

    @Published var eventsForYou: [EventListModel] = []
    @Published var eventsFollowedUsers: [EventListModel] = []
    @Published var isLoading = false

    func getEventsForYou() async {
        isLoading = true
        let eventsApi = await repository.getEventsForYou()
        // Mapea el resultado y si las urls de las imagenes no tienen el protocolo http se lo añade para que se puedan cargar
        eventsForYou = eventsApi.map { event in
            var event = event
            event.photoOrganiser = Constants.validateUrlImage(url: event.photoOrganiser, urlBase: Constants.urlBaseImage)
            event.photoEvent = Constants.validateUrlImage(url: event.photoEvent, urlBase: Constants.urlBaseImage)
            return event
        }
        isLoading = false
    }

    func getEventsFollowedUsers() async {
        isLoading = true
        let eventsApi = await repository.getEventsFollowedUsers()
        eventsFollowedUsers = eventsApi.map { event in
            var event = event
            event.photoOrganiser = Constants.validateUrlImage(url: event.photoOrganiser, urlBase: Constants.urlBaseImage)
            event.photoEvent = Constants.validateUrlImage(url: event.photoEvent, urlBase: Constants.urlBaseImage)
            return event
        }
        isLoading = false
    }

    
}
