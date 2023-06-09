//
//  LoginHomeViewModel.swift
//  qddapp
//
//  Created by gabatx on 19/5/23.
//

import Foundation

enum StateLogin{
    case success
    case isNotRegister
    case isNotVerified
    case invalidCredentials
    case emailNotVerified
}

@MainActor
class LoginHomeViewModel: ObservableObject {

    let repository: LoginHomeRepositoryProtocol = LoginHomeRepositoryApiRest()

    @Published var email: String = ""
    @Published var emailRestore: String = ""
    @Published var password: String = ""
    @Published var isRegister: Bool = false
    @Published var isForgotPassword: Bool = false
    @Published var isShowLoading: Bool = false
    @Published var isShowPassword: Bool = false
    @Published var isShowErrorEmail: Bool = false
    @Published var isShowErrorPassword: Bool = false
    @Published var isShowTermsOfUse: Bool = false
    @Published var typeError: ErrorsResponseLogin = .emailNotVerified
    @Published var stateLogin: StateLogin = .success

    @discardableResult
    func emailSucess() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        if NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email) {
            isShowErrorEmail = false
            return true
        }
        isShowErrorEmail = true
        return false
    }

    @discardableResult
    func passwordSucess() -> Bool {
        if password.count >= 8 {
            isShowErrorPassword = false
            return true
        }
        isShowErrorPassword = true
        return false
    }

    func isValidateForm() -> Bool {
        emailSucess()
        passwordSucess()
        return emailSucess() && passwordSucess()
    }

    func loginRequest(loginData: LoginRequestModel) async {
        isShowLoading = true
        let result = await repository.login(loginData: loginData)

        // PREPARAMOS ESTADOS DEPENDIENDO DE LA RESPUESTA
        switch result {
        case .success(let loginModel):
            print("Login correcto: \(loginModel)")

            if loginModel.isVerified == 0 {
                stateLogin = .isNotVerified
                isShowLoading = false
                return
            }

            if loginModel.isVerified == 1 && loginModel.isRegistered == 0 {
                saveIdAndToken(loginModel: loginModel)
                stateLogin = .isNotRegister
                isShowLoading = false
                return
            }

            if loginModel.isVerified == 1 && loginModel.isRegistered == 1 {
                UserDefaultsManager.shared.isUserLoggedIn = true
                saveIdAndToken(loginModel: loginModel)
                stateLogin = .success
                isShowLoading = false
                return
            }

        case .failure(let error):
            isShowLoading = false
            typeError = ErrorsResponseLogin(rawValue: error.error) ?? .emailNotVerified


            if typeError == .emailNotVerified {
                stateLogin = .emailNotVerified
                return
            }

            if typeError == .invalidCredentials {
                stateLogin = .invalidCredentials
                print("Error en el login: \(typeError.errorDescription ?? "Error desconocido")")
                return
            }
        }
    }

    func sendEmailRestoreToServer() {
        print("Email enviado al servidor")
    }

    func saveIdAndToken(loginModel: LoginResponseModel ){
        // Introducimos el id de usuario y Token en UserDefault
        UserDefaultsManager.shared.userID = String(describing: loginModel.id)
        UserDefaultsManager.shared.userToken = loginModel.token
        // Imprimimos los datos guardados
        if let userID = UserDefaultsManager.shared.userID { print("User ID: \(userID)") }
        if let userToken = UserDefaultsManager.shared.userToken { print("User Token: \(userToken)") }
    }
}
