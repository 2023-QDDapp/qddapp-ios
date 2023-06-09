//
//  RegisterFormRepository.swift
//  qddapp
//
//  Created by gabatx on 21/5/23.
//

import Foundation

protocol RegisterFormRepositoryProtocol {
    func getResponseIfPhoneSuccess(phone: PhoneValidateRequest) async -> String
    func sendFullUserRegistrationDataModel(data: SendFullUserRegistrationDataModel) async -> String
    // Editar usuario
    func getProfileData(idUser: Int) async -> UserModel
    func getImageProfile(url: String) async -> Data
    func updateProfileData(data: UserEditProfileModel) async -> MessageResponseModel
}

class RegisterFormRepositoryApiRest {
    let requestManager: NetworkManager = NetworkManager(urlBase: Constants.urlBase)
}

extension RegisterFormRepositoryApiRest: RegisterFormRepositoryProtocol{

    func getResponseIfPhoneSuccess(phone: PhoneValidateRequest) async -> String {
        let endPoint = "validate/phone"
        let result = try! await (requestManager.post(endPoint: endPoint, body: phone) as MessageResponseModel).message
        return result
    }

    func sendFullUserRegistrationDataModel(data: SendFullUserRegistrationDataModel) async -> String {
        // Obtenemos el usuario de userDefaults sin manager
        guard let userID = UserDefaultsManager.shared.userID else { return "No ha sido posible obtener el id" }
        guard let token = UserDefaultsManager.shared.userToken else { return "No ha sido posible obtener el token" }

        // Añadimos el id del usuario al modelo
        let endPoint = "continue/register/\(String(describing: userID))"
        let result = try! await (requestManager.post(endPoint: endPoint, body: data, token: (String(describing: token))) as MessageResponseModel).message
        return result
    }

    // ----- Editar Usuario

    func getProfileData(idUser: Int) async -> UserModel {
        let endPoint = "users/\(idUser)"
        do {
            return try await requestManager.get(endPoint: endPoint)
        } catch {
            print("Error en la obtención de datos: \(error)")
            return DateFake.user
        }
    }

    func getImageProfile(url: String) async -> Data {
        return await requestManager.getImage(url: url)
    }

    func updateProfileData(data: UserEditProfileModel) async -> MessageResponseModel {
        guard let userID = UserDefaultsManager.shared.userID else { return DateFake.messageResponseModel }
        guard let userToken = UserDefaultsManager.shared.userToken else { return DateFake.messageResponseModel }

        let endPoint = "users/\(userID)/edit"
        do {
            return try await requestManager.put(endPoint: endPoint, body: data, token: userToken)
        } catch {
            print("Error en la obtención de datos: \(error)")
            return DateFake.messageResponseModel
        }
    }

}
