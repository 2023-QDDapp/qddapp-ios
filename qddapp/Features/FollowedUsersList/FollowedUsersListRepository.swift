//
//  FollowedUsersListRepository.swift
//  qddapp
//
//  Created by gabatx on 30/5/23.
//

import Foundation

protocol FollowedUsersListRepositoryProtocol {
    func getFollowedUsersList() async -> [FollowedUser]
}

class FollowedUsersListRepositoryApiRest {
    let requestManager: NetworkManager = NetworkManager(urlBase: Constants.urlBase)
}

extension FollowedUsersListRepositoryApiRest: FollowedUsersListRepositoryProtocol {

    func getFollowedUsersList() async -> [FollowedUser] {
        let user = UserDefaultsManager.shared.userID ?? ""
        let endPoint = "users/\(user)/following"
        do {
            return try await requestManager.get(endPoint: endPoint)
        } catch {
            print("Error en la obtención de datos: \(error)")
            return []
        }
    }
}
