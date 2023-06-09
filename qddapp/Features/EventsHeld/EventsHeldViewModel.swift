//
//  EventsHeldViewModel.swift
//  qddapp
//
//  Created by gabatx on 8/6/23.
//

import Foundation

@MainActor
class EventsHeldViewModel: ObservableObject {

    let repository: EventsHeldRepositoryProtocol = EventsHeldRepositoryApiRest()

    @Published var eventsAttended: [EventHeldCellModel] = []
    @Published var eventsHistory: [EventHeldCellModel] = []
    @Published var isUserLogin = false
    @Published var isLoading = true

    func getMyEvents() async {
        isLoading = true
        let userLogin = Int(UserDefaultsManager.shared.userID!)!
        eventsAttended = await repository.getMyEvents(idUser: userLogin)
        isLoading = false
    }

    func getEventsHeldHistory() async {
        isLoading = true
        let userLogin = Int(UserDefaultsManager.shared.userID!)!
        eventsHistory = await repository.getEventsHeldHistory(idUser: userLogin)
        isLoading = false
    }

    func validateInUser(idOrganizer: Int)  {
        //print("idOrganizer:", idOrganizer)
        //print("userID:", UserDefaultsManager.shared.userID!)
        isUserLogin = Int(UserDefaultsManager.shared.userID!)! == idOrganizer
    }

}
