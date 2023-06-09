//
//  LoginHomeRepository.swift
//  qddapp
//
//  Created by gabatx on 19/5/23.
//

import Foundation

enum LoginResult<T, E> where E: Error {
    case success(T)
    case failure(E)
}

protocol LoginHomeRepositoryProtocol {
    func login(loginData: LoginRequestModel) async -> LoginResult<LoginResponseModel, ErrorMessageModel>
}

class LoginHomeRepositoryApiRest {
    let requestManager: NetworkManager = NetworkManager(urlBase: Constants.urlBase)
}

extension LoginHomeRepositoryApiRest: LoginHomeRepositoryProtocol {
    func login(loginData: LoginRequestModel) async -> LoginResult<LoginResponseModel, ErrorMessageModel> {
        let endPoint = "loginApi"
        do {
            let loginResponseModel: LoginResponseModel = try await requestManager.post(endPoint: endPoint, body: loginData)
            return .success(loginResponseModel)
        } catch let error {
            if let loginError = error as? ErrorMessageModel {
                return .failure(loginError)
            } else {
                let errorDescription = (error as NSError).localizedDescription
                let loginError = ErrorMessageModel(error: errorDescription)
                return .failure(loginError)
            }
        }
    }
}
