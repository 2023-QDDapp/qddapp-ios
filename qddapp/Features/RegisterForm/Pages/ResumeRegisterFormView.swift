//
//  ResumeRegisterFormView.swift
//  qddapp
//
//  Created by gabatx on 22/5/23.
//

import SwiftUI

struct ResumeRegisterFormView: View {
    @EnvironmentObject var routingViewModel: RoutingViewModel
    @EnvironmentObject var categoriesViewModel: CategoriesViewModel
    @EnvironmentObject var registerFormViewModel: RegisterFormViewModel
    @EnvironmentObject var popupViewModel: PopupViewModel
    @State var showAlertErrorValidationForm = false
    @State var showAlertConfirm = false
    @State var isLoadingSendDataProfile = false

    var body: some View {

        ZStack{
            VStack(spacing: 20){
                Text("¿Listo para Empezar?")
                    .modifier(h3(color: (Color(LocalizedColor.secondary))))
                    .multilineTextAlignment(.center)
                Text("Puedes revisar y ajustar la configuración de tu cuenta para asegurarte de que todo esté correctamente")
                    .modifier(body1())
                    .multilineTextAlignment(.center)
                Button {
                    if validateFormRegisterSuccess(){

                        Task{
                            isLoadingSendDataProfile = true
                            if await registerFormViewModel.sendDataToRegisterUser(idsCategoriesSelected: categoriesViewModel.idCategoriesSelected) {
                                routingViewModel.view = .mainScreenView
                            }
                            isLoadingSendDataProfile = false
                        }
                    }else{
                        showAlertErrorValidationForm = true
                    }
                } label: {
                    Text("¡A planear!")
                        .modifier(body1(color: .white))
                }
                .buttonStandarDesignLogin(color: Color(LocalizedColor.secondary))
                .alert(isPresented: $showAlertErrorValidationForm) {
                    Alert(title: Text("Datos inválidos"), message: Text("Revisa el formulario de registro, hay datos incorrectos"), dismissButton: .default(Text("OK")))
                }
            }
            if isLoadingSendDataProfile {
                ProgressView("")
            }
        }
        .padding(Constants.paddingLoginHome)
    }


    func validateFormRegisterSuccess() -> Bool{
        return !registerFormViewModel.showNameError &&
        !registerFormViewModel.showdateOfBirthError &&
        !registerFormViewModel.showPhoneError &&
        !registerFormViewModel.showPhoneErrorPhoneExists &&
        !registerFormViewModel.showAvatarError &&
        !registerFormViewModel.showDescriptionError &&
        !categoriesViewModel.showNumbersOfCategoriesError
    }
}

struct ResumeRegisterFormView_Previews: PreviewProvider {
    static var previews: some View {
        ResumeRegisterFormView()
            .environmentObject(RoutingViewModel())
            .environmentObject(RegisterFormViewModel())
            .environmentObject(PopupViewModel())
            .environmentObject(CategoriesViewModel())
    }
}
