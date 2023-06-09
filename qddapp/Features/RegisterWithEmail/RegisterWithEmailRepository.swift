//
//  RegisterWithEmailRepository.swift
//  qddapp
//
//  Created by gabatx on 21/5/23.
//

import Foundation

enum RegisterResult<T, E> where E: Error {
    case success(T)
    case failure(E)
}

protocol RegisterWithEmailRepositoryPrococol {
    func sendRegisterEmail(data: RegisterEmailRequestLoginModel) async -> RegisterResult<RegisterEmailResponseLoginModel, ErrorMessageModel>
}

class RegisterWithEmailRepositoryApiRest {
    var requestManager: NetworkManager = NetworkManager(urlBase: Constants.urlBase)
}

extension RegisterWithEmailRepositoryApiRest: RegisterWithEmailRepositoryPrococol {

    func sendRegisterEmail(data: RegisterEmailRequestLoginModel) async -> RegisterResult<RegisterEmailResponseLoginModel, ErrorMessageModel> {
        let endPoint = "register"
        do {
            let registerEmailResponse: RegisterEmailResponseLoginModel = try await requestManager.post(endPoint: endPoint, body: data)
            return .success(registerEmailResponse)
        } catch let error {
            if let registerEmailError = error as? ErrorMessageModel {
                return .failure(registerEmailError)
            } else {
                let errorDescription = (error as NSError).localizedDescription
                let loginError = ErrorMessageModel(error: errorDescription)
                return .failure(loginError)
            }
        }
    }
}
