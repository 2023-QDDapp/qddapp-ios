//
//  RegisterWithEmailView.swift
//  qddapp
//
//  Created by gabatx on 21/5/23.
//

import SwiftUI

struct RegisterWithEmailView: View {

    @EnvironmentObject var registerWithEmailViewModel: RegisterWithEmailViewModel
    @EnvironmentObject var loginHomeViewModel: LoginHomeViewModel
    @EnvironmentObject var popupViewModel: PopupViewModel

    var body: some View {
        ScrollView {
            ZStack {
                VStack(spacing: 40){

                    // Botón cerrar
                    HStack {
                        Spacer()
                        Button {
                            registerWithEmailViewModel.showRegisterWithEmailView = false
                        } label: {
                            Image("cerrar")
                                .styleBasicImageLogo()
                                .frame(width: 20)
                        }
                    }
                    // Título registro
                    HStack {
                        Spacer()
                        Text("Registro")
                            .modifier(h1())
                            .foregroundColor(Color(LocalizedColor.primary))
                        Spacer()
                    }
                    .padding(.top, -20)
                    // Input correo electrónico
                    VStack{
                        // TextField con onEditingChanged
                        TextField("Introduce tu correo electrónico", text: $registerWithEmailViewModel.email, onEditingChanged: { (isChanged) in
                            if !isChanged {
                                Task {
                                    await registerWithEmailViewModel.validateEmail()
                                }
                            }
                        })
                        .modifier(body1())
                        Divider()
                            .frame(height: 0.4)
                            .padding(.horizontal, 30)
                            .background(Color(LocalizedColor.grayIconTextField))
                            .overlay(alignment: .topTrailing ){
                                if registerWithEmailViewModel.isShowErrorEmail {
                                    Text(registerWithEmailViewModel.stateEmail.rawValue)
                                        .modifier(messageUnderDivider())
                                        .foregroundColor(Color(LocalizedColor.errorValidation))
                                        .padding(.top, 5)
                                }

                            }
                    }
                    // Input contraseña
                    VStack{
                        HStack{
                            if registerWithEmailViewModel.isShowPassword {
                                TextField("Introduce tu contraseña", text: $registerWithEmailViewModel.password)
                                    .modifier(body1())
                                    .frame(height: 25)
                            } else {
                                SecureField("Introduce tu contraseña", text: $registerWithEmailViewModel.password)
                                    .modifier(body1())
                                    .frame(height: 25)
                            }
                            Button {
                                registerWithEmailViewModel.isShowPassword.toggle()
                            } label: {
                                Image(systemName: registerWithEmailViewModel.isShowPassword ? LocalizedImage.eye : LocalizedImage.eyeSlash)
                                    .foregroundColor(Color(LocalizedColor.grayIconTextField))
                            }
                        }

                        Divider()
                            .frame(height: 0.4)
                            .padding(.horizontal, 30)
                            .background(Color(LocalizedColor.grayIconTextField))
                            .overlay(alignment: .topTrailing ){
                                if registerWithEmailViewModel.isShowErrorPassword {
                                    Text(registerWithEmailViewModel.statePassword.rawValue)
                                        .modifier(messageUnderDivider())
                                        .foregroundColor(Color(LocalizedColor.errorValidation))
                                        .padding(.top, 5)
                                }
                            }
                    }
                    // Input repite contraseña
                    VStack{
                        HStack{
                            if registerWithEmailViewModel.isShowRepeatPassword {
                                TextField("Vuelve a introducir tu contraseña", text: $registerWithEmailViewModel.repeatPassword)
                                    .modifier(body1())
                                    .frame(height: 25)
                            } else {
                                SecureField("Vuelve a introducir tu contraseña", text: $registerWithEmailViewModel.repeatPassword)
                                    .modifier(body1())
                                    .frame(height: 25)
                            }
                            Button {
                                registerWithEmailViewModel.isShowRepeatPassword.toggle()
                            } label: {
                                Image(systemName: registerWithEmailViewModel.isShowRepeatPassword ? LocalizedImage.eye : LocalizedImage.eyeSlash)
                                    .foregroundColor(Color(LocalizedColor.grayIconTextField))
                            }
                        }

                        Divider()
                            .frame(height: 0.4)
                            .padding(.horizontal, 30)
                            .background(Color(LocalizedColor.grayIconTextField))
                            .overlay(alignment: .topTrailing ){
                                if registerWithEmailViewModel.isShowErrorRepeatPassword {
                                    Text(registerWithEmailViewModel.stateRepeatPassword.rawValue)
                                        .modifier(messageUnderDivider())
                                        .foregroundColor(Color(LocalizedColor.errorValidation))
                                        .padding(.top, 5)
                                }
                            }
                    }
                    // Botón continuar
                    Button {
                        Task{
                            await registerWithEmailViewModel.isValidateForm()
                        }
                    } label: {
                        Text("Continuar")
                            .modifier(h5(color: .white))
                            .alert(isPresented: $registerWithEmailViewModel.showPopupSuccess) {
                                Alert(title: Text("Registro satisfactorio"), message: Text("Ya puedes validar el correo que te hemos enviado"), dismissButton: .default(Text("Aceptar"), action: {
                                    withTransaction(Transaction.init(animation: .easeIn)) {
                                        registerWithEmailViewModel.showRegisterWithEmailView = false
                                    }
                                }))
                            }

                    }
                    .buttonStandarDesignLogin()
                    // Texto recordatorio
                    Text("Recuerda, te enviaremos un link a tu correo para que actives tu cuenta. Una vez realizada la activación vuelve para iniciar sesión.")
                        .modifier(body1())
                        .multilineTextAlignment(.center)
                    Spacer()

                }
                .padding(Constants.paddingLoginHome)

                if registerWithEmailViewModel.isLoadingSendRegister {
                    ProgressView()
                }
            }

        }
        .onTapGesture {
            self.hideKeyboard()
        }
    }
}

struct RegisterWithEmailView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterWithEmailView()
            .environmentObject(RegisterWithEmailViewModel())
            .environmentObject(LoginHomeViewModel())
    }
}
