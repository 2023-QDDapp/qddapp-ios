//
//  RegisterFormViewModel.swift
//  qddapp
//
//  Created by gabatx on 21/5/23.
//

import Foundation
import SwiftUI

enum PhoneResponse: String {
    case phoneError = "El teléfono ya existe"
    case phoneSuccess = "El teléfono es válido"
}

enum MessageReponse: String {
    case success = "Registro completado correctamente."
}

@MainActor
class RegisterFormViewModel: ObservableObject{

    let repository: RegisterFormRepositoryProtocol = RegisterFormRepositoryApiRest()

    // Errores:
    @Published var showNameError = false
    @Published var showdateOfBirthError = false
    @Published var showPhoneError = false
    @Published var showPhoneErrorPhoneExists = false
    @Published var showAvatarError = false
    @Published var showDescriptionError = false
    @Published var showPreferencesError = false
    // Nombre
    @Published var name = ""
    // Fecha de nacimiento
    @Published var selectedDayOfBirth = 0
    @Published var selectedMonthOfBirth = Constants.notSelected
    @Published var selectedYearOfBirth = 0
    @Published var variableDay = Date().daysInMonth()
    @Published var showPickerViewDayOfBirth = false
    @Published var showPickerViewMonthOfBirth = false
    @Published var showPickerViewYearOfBirth = false
    @Published var dateOfBirth = ""
    // Teléfono:
    @Published var phone = ""
    @Published var isLoadingValidatePhone = false
    // Avatar: (Image Picker)
    @Published var profileImage: Image = Image(Constants.imageEventTemplate) // Imagen que nos permite mostrar la imagen seleccionada
    @Published var imageData : Data = .init(capacity: 0) // Almacena la imagen seleccionada
    @Published var showImagePicker: Bool = false // Permite mostrar el ImagePicker
    @Published var showAlertCameraOrGallery = false
    @Published var source : UIImagePickerController.SourceType = .camera
    // Sobre mi:
    @Published var placeholderAboutMe: String = "Escribe algo sobre ti..."
    @Published var descriptionUser: String = ""
    @Published var isShowPlaceHolder = true
    @Published var isWriting = true

    // ----- Editar Usuario ----
    @Published var profileData: UserModel = DateFake.user
    @Published var isLoading = false

    private let minCharactersName = 30

    // MARK: - Nombre
    func checkName() {
        if name.count < 5 {
            showNameError = true
        } else {
            showNameError = false
        }
    }

    // MARK: - Fecha de nacimiento
    func setVariableDay(newValue: String){
        // Cambia los días a 28, 29, 30 o 31 dependiendo del mes y el año seleccionado
        if newValue == "febrero" {
            if Date().isLeapYear(year: selectedYearOfBirth) {
                variableDay = 29
            } else {
                variableDay = 28
            }
        } else if newValue == "abril" || newValue == "junio" || newValue == "septiembre" || newValue == "noviembre" {
            variableDay = 30
        } else {
            variableDay = 31
        }
        setLastDayOfMonth()
    }

    func adjustDaysForLeapYearFebruary(newValue: Int){
        if selectedMonthOfBirth == "febrero" {
            if Date().isLeapYear(year: newValue) {
                variableDay = 29
            } else {
                variableDay = 28
            }
        }
        setLastDayOfMonth()
    }

    func setLastDayOfMonth(){
        if selectedDayOfBirth > variableDay {
            selectedDayOfBirth = variableDay
        }
    }

    func checkDateOfBirth(){
        showdateOfBirthError = selectedDayOfBirth == 0 || selectedMonthOfBirth == Constants.notSelected || selectedYearOfBirth == 0
    }

    func createDate(){
        if showdateOfBirthError == false {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd"
            let date = dateFormatter.date(from: "\(selectedYearOfBirth)/\(monthToNumber(month: selectedMonthOfBirth))/\(selectedDayOfBirth)")!
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: date)
            dateOfBirth = dateString
        }
    }

    // Convierte el mes (Enero, Febrero, etc) a un número
    func monthToNumber(month: String) -> Int {
        let months = ["enero": 1, "febrero": 2, "marzo": 3, "abril": 4, "mayo": 5, "junio": 6, "julio": 7, "agosto": 8, "septiembre": 9, "octubre": 10, "noviembre": 11, "diciembre": 12]
        return months[month.lowercased()] ?? 0
    }

    // MARK: - Teléfono
    // Chequea que el teléfono tenga 9 dígitos y que empiece por 6, 7, 8 o 9 con regex
    func isCorrectPhoneFormat() -> Bool {
        let phoneRegex = "^[6-9]\\d{8}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phone)
    }

    func checkPhone() async {
        showPhoneError = !isCorrectPhoneFormat()
        if !showPhoneError {
            isLoadingValidatePhone = true
            showPhoneErrorPhoneExists = await !getResponseIfPhoneSuccess()
            isLoadingValidatePhone = false
        } else {
            showPhoneErrorPhoneExists = true
        }
    }

    func checkPhoneEditUser() async {
        // Si el teléfono es el mismo que el que ya tenía, no muestra error
        if phone == profileData.phone {
            showPhoneError = false
            showPhoneErrorPhoneExists = false
        } else {
            showPhoneError = !isCorrectPhoneFormat()
            if !showPhoneError {
                isLoadingValidatePhone = true
                showPhoneErrorPhoneExists = await !getResponseIfPhoneSuccess()
                isLoadingValidatePhone = false
            } else {
                showPhoneErrorPhoneExists = true
            }
        }
    }

    // MARK: - Avatar
    func checkAvatar(){
        if imageData.count == 0 {
            showAvatarError = true
        } else {
            showAvatarError = false
        }
    }

    func loadImage(imageData: Data) {
        if imageData.count != 0 {
            profileImage = Image(uiImage: UIImage(data: imageData)!)
        }
    }

    // MARK: - Description
    func checkDescription(){
        if descriptionUser.count < minCharactersName {
            showDescriptionError = true
        } else {
            showDescriptionError = false
        }
    }

    // MARK: - Send to Api:
    func getResponseIfPhoneSuccess() async -> Bool {
        let numberPhone = PhoneValidateRequest(numberPhone: phone)
        let result = await repository.getResponseIfPhoneSuccess(phone: numberPhone)
        return result == PhoneResponse.phoneSuccess.rawValue
    }

    func sendDataToRegisterUser(idsCategoriesSelected: [Int]) async -> Bool {
        let data = SendFullUserRegistrationDataModel(name: name,
              birthDate: dateOfBirth,
              phone: phone,
              photo: imageData.toBase64(),
              biography: descriptionUser,
              categories: idsCategoriesSelected)

        if await repository.sendFullUserRegistrationDataModel(data: data) == MessageReponse.success.rawValue {
            UserDefaultsManager.shared.isUserLoggedIn = true
            return true
        }
        UserDefaultsManager.shared.isUserLoggedIn = false
        return false
    }

    // ---- Editar usuario ----
    func getProfileData(idUser: Int) async {
        isLoading = true
        profileData = await repository.getProfileData(idUser: idUser)
        name = profileData.name
        phone = profileData.phone
        descriptionUser = profileData.description
        imageData = await repository.getImageProfile(url: profileData.photo)
        isLoading = false
    }

    func updateProfileData(idsInterests: [Int]) async -> Bool {
        let data = UserEditProfileModel(
            name: name,
            photo: imageData.toBase64(),
            phone: phone,
            biography: descriptionUser,
            interests: idsInterests)
        let result = await repository.updateProfileData(data: data).message
        return result.contains("Se ha actualizado el usuario")
    }

    // Validamos los campos del formulario editar: avatar, nombre, teléfono, descripción y categorías
    func checkFieldsEditUser(idsInterests: [Int]) async -> Bool {
        checkAvatar()
        checkName()
        await checkPhoneEditUser()
        checkDescription()
        return !showAvatarError && !showNameError && !showPhoneError && !showDescriptionError && !showPhoneErrorPhoneExists && idsInterests.count == 3
    }

    // Si hay errores los mostramos
    func showErrorsEditUser(idsInterests: [Int]) {
        if showAvatarError {
            showAvatarError = true
        }
        if showNameError {
            showNameError = true
        }
        if showPhoneError {
            showPhoneError = true
        }
        if showDescriptionError {
            showDescriptionError = true
        }
        if showPhoneErrorPhoneExists {
            showPhoneErrorPhoneExists = true
        }
    }

}
