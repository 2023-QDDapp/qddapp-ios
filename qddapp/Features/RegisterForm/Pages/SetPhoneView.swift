//
//  SetPhoneView.swift
//  qddapp
//
//  Created by gabatx on 21/5/23.
//

import SwiftUI

struct SetPhoneView: View {

    @EnvironmentObject var registerFormViewModel: RegisterFormViewModel
    var isEditUser = false

    init(isEditUser: Bool = false) {
        self.isEditUser = isEditUser
    }

    var body: some View {
        VStack(spacing: 20){
            if !isEditUser {
                Text("¿Podrías decirnos tu teléfono?")
                    .modifier(h3(color: (Color(LocalizedColor.secondary))))
                    .multilineTextAlignment(.center)
                Text("Lo necesitamos para proporcionar seguridad a nuestros usuarios. No se mostrará en tu perfil.")
                    .modifier(body1())
                    .multilineTextAlignment(.center)
            }

            VStack{
                ZStack{
                    HStack{
                        if registerFormViewModel.isLoadingValidatePhone {
                            ProgressView("")
                        }
                        Spacer()
                    }
                    TextField("Introduce tu teléfono", text: $registerFormViewModel.phone.max(9), onEditingChanged: { (isChanged) in
                        if !isChanged {
                            Task{
                                if isEditUser {
                                    await registerFormViewModel.checkPhoneEditUser()
                                } else {
                                    await registerFormViewModel.checkPhone()
                                }
                            }
                        }
                    })
                    .multilineTextAlignment(isEditUser ? .leading :.center)
                    .modifier(body1())
                    .keyboardType(.numberPad)
                }

                Divider()
                    .lineBottom(color: registerFormViewModel.showPhoneError ? .red : Color(LocalizedColor.grayIconTextField))
                    .overlay(alignment: .center){
                        if registerFormViewModel.showPhoneError {
                            Text("No es un número de teléfono válido (9 cifras)")
                                .modifier(messageUnderDivider())
                                .foregroundColor(Color(LocalizedColor.errorValidation))
                                .padding(.top, 25)
                        } else if registerFormViewModel.showPhoneErrorPhoneExists {
                            Text("El número de teléfono ya existe")
                                .modifier(messageUnderDivider())
                                .foregroundColor(Color(LocalizedColor.errorValidation))
                                .padding(.top, 25)
                        }
                    }
            }
        }
        .padding(.horizontal, isEditUser ? 0 : Constants.paddingLoginHome)
        .onDisappear(){
            Task{
                if isEditUser {
                    await registerFormViewModel.checkPhoneEditUser()
                } else {
                    await registerFormViewModel.checkPhone()
                }
            }
        }
    }
}

struct SetPhoneView_Previews: PreviewProvider {
    static var previews: some View {
        SetPhoneView()
            .environmentObject(RegisterFormViewModel())
    }
}
