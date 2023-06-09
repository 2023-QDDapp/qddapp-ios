//
//  RegisterWithEmailViewModel.swift
//  qddapp
//
//  Created by gabatx on 21/5/23.
//

import Foundation

enum RegisterWithEmailViewModelState: String {
    case emailError = "El email no es correcto"
    case passwordError = "La contraseña debe tener al menos 8 caracteres"
    case repeatPasswordError = "Las contraseñas no coinciden"
    case fieldEmpty = "El campo no puede estar vacío"
    case emailExists = "El email ya existe"
}

@MainActor
class RegisterWithEmailViewModel: ObservableObject {

    let repository = RegisterWithEmailRepositoryApiRest()

    @Published var email = ""
    @Published var password = ""
    @Published var repeatPassword = ""
    @Published var isShowErrorEmail = false
    @Published var isShowPassword = false
    @Published var isShowRepeatPassword = false
    @Published var isShowErrorPassword = false
    @Published var isShowErrorRepeatPassword = false

    @Published var showRegisterWithEmailView = false
    @Published var showEmailExist = false
    @Published var showPopupSuccess = false
    @Published var isLoadingSendRegister = false
    
    @Published var stateEmail: RegisterWithEmailViewModelState = .fieldEmpty
    @Published var statePassword: RegisterWithEmailViewModelState = .fieldEmpty
    @Published var stateRepeatPassword: RegisterWithEmailViewModelState = .fieldEmpty

    func emailSucess() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"

        if NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email) {
            isShowErrorEmail = false
            return true
        }
        isShowErrorEmail = true
        return false
    }

    func passwordSucess() -> Bool {
        return password.count >= 8
    }

    func repeatPasswordSucess() -> Bool {
        return repeatPassword.count >= 8
    }

    private func passwordsAreEqual() -> Bool {
        password == repeatPassword
    }

    private func cleanInputs(){
        email = ""
        password = ""
        repeatPassword = ""
    }

    func validateEmail() async {
        if email.isEmpty {
            isShowErrorEmail = true
            stateEmail = .fieldEmpty
            return
        }

        if !emailSucess() {
            isShowErrorEmail = true
            stateEmail = .emailError
            return
        }

        if await checkIfEmailExists(email: email) {
            isShowErrorEmail = true
            stateEmail = .emailExists
            return
        }

        isShowErrorEmail = false
    }

    func validatePassword() {
        if password.isEmpty {
            isShowErrorPassword = true
            statePassword = .fieldEmpty
            return
        }

        if !passwordSucess() {
            isShowErrorPassword = true
            statePassword = .passwordError
            return
        }

        if !passwordsAreEqual() {
            isShowErrorPassword = true
            statePassword = .repeatPasswordError
            return
        }

        isShowErrorPassword = false

    }

    func validateRepeatPassword() {
        if repeatPassword.isEmpty {
            isShowErrorRepeatPassword = true
            stateRepeatPassword = .fieldEmpty
            return
        }

        if !repeatPasswordSucess() {
            isShowErrorRepeatPassword = true
            stateRepeatPassword = .passwordError
            return
        }

        if !passwordsAreEqual() {
            isShowErrorRepeatPassword = true
            stateRepeatPassword = .repeatPasswordError
            return
        }

        isShowErrorRepeatPassword = false
    }

    func isValidateForm() async {
        await validateEmail()
        validatePassword()
        validateRepeatPassword()
        if !isShowErrorEmail && !isShowErrorPassword && !isShowErrorRepeatPassword {

            isLoadingSendRegister = true
            let data:  RegisterEmailRequestLoginModel = .init(email: email, password: password)
            let result = await repository.sendRegisterEmail(data: data)
            isLoadingSendRegister = false

            switch result {
            case .success(let registerResult):
                print(registerResult.message)
                showPopupSuccess = true
                isShowErrorEmail = false
                showEmailExist = false
                cleanInputs()

            case .failure(let error):
                stateEmail = .emailExists
                isShowErrorEmail = true
                print(error.localizedDescription)
                showEmailExist = true
            }

        }
    }

    func checkIfEmailExists(email: String) async -> Bool {
        let emailMock = "correo.cualquiera@gmail.com"
        return await withCheckedContinuation { continuation in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                continuation.resume(returning: emailMock == email)
            }
        }
    }
}
