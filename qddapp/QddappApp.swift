//
//  qddappApp.swift
//  qddapp
//
//  Created by gabatx on 13/4/23.
//

import SwiftUI

@main
struct QddappApp: App {
    var body: some Scene {
        WindowGroup {
            let routingView = RoutingViewModel()
            let loginHomeViewModel = LoginHomeViewModel()
            let registerWithEmailViewModel = RegisterWithEmailViewModel()
            let mainScreenViewModel = MainScreenViewModel()
            let homeViewModel = HomeViewModel()
            let eventDetailViewModel = EventDetailViewModel()
            let listOfParticipantsViewModel = ListOfParticipantsViewModel()
            let searchEventViewModel = SearchEventByKeywordViewModel()
            let offlineDataManagerViewModel = OfflineDataManagerViewModel()
            let searchEventFilterViewModel = SearchEventFilterViewModel()
            let categoriesViewModel = CategoriesViewModel()
            let mapFilterViewModel = MapFilterViewModel()
            let locationManager = LocationManager()
            let searchEventResultViewModel = SearchEventResultViewModel()
            let eventCreateViewModel = EventCreateViewModel()
            let settingsViewModel = SettingsViewModel()
            let followedUsersListViewModel = FollowedUsersListViewModel()
            let popupViewModel = PopupViewModel()

            ContentView()
                .environmentObject(routingView)
                .environmentObject(loginHomeViewModel)
                .environmentObject(registerWithEmailViewModel)
                .environmentObject(mainScreenViewModel)
                .environmentObject(homeViewModel)
                .environmentObject(eventDetailViewModel)
                .environmentObject(listOfParticipantsViewModel)
                .environmentObject(searchEventViewModel)
                .environmentObject(offlineDataManagerViewModel)
                .environmentObject(searchEventFilterViewModel)
                .environmentObject(categoriesViewModel)
                .environmentObject(mapFilterViewModel)
                .environmentObject(locationManager)
                .environmentObject(searchEventResultViewModel)
                .environmentObject(eventCreateViewModel)
                .environmentObject(settingsViewModel)
                .environmentObject(followedUsersListViewModel)
                .environmentObject(popupViewModel)
        }
    }
}

