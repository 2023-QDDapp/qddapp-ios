//
//  SettingsViewModel.swift
//  qddapp
//
//  Created by gabatx on 14/5/23.
//

import Foundation

enum StateSettings {
    case success(userId: String)

    var message: String {
        switch self {
        case .success(let userId):
            return "Se ha eliminado el usuario #\(userId)"
        }
    }
}

@MainActor
class SettingsViewModel:ObservableObject {

    let repository: SettingsRepositoryProtocol = SettingsRepositoryApiRest()
    @Published var isLoadingDeleteUserAccount = false
    @Published var showAlertConfirmDeleteUser = false

    func deleteUser() async {
        guard
            let userID = UserDefaultsManager.shared.userID,
            let userToken = UserDefaultsManager.shared.userToken
        else { return }
        isLoadingDeleteUserAccount = true
        let result = await repository.deleleUserAccount(idUser: userID, token: userToken)
        if result.message == StateSettings.success(userId: userID).message {
            isLoadingDeleteUserAccount = false
        }
        isLoadingDeleteUserAccount = false
    }

    func closeSession() {
        UserDefaultsManager.shared.isUserLoggedIn = false
    }
}
