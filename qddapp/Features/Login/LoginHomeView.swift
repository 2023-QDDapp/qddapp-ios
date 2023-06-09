//
//  LoginHomeView.swift
//  qddapp
//
//  Created by gabatx on 19/5/23.
//

import SwiftUI

struct LoginHomeView: View {

    @EnvironmentObject var routingViewModel: RoutingViewModel
    @EnvironmentObject var loginHomeViewModel: LoginHomeViewModel
    @EnvironmentObject var popupViewModel: PopupViewModel
    @StateObject var registerWithEmailViewModel = RegisterWithEmailViewModel()

    var body: some View {

        ZStack(alignment: .center) {
            ScrollView {
                ZStack {
                    VStack(spacing: 50){
                        Spacer()
                        // Logo
                        VStack{
                            Image(LocalizedImage.logo)
                                .styleBasicImageLogo()
                                .frame(width: 150)
                            Group{
                                Text("Busca ") +
                                Text("plan ").bold() +
                                Text("y anímate a ") +
                                Text("salir de casa").bold()
                            }
                            .modifier(body1())
                            .padding(.top, 20)
                        }

                        // Inputs
                        VStack(spacing: 20){
                            VStack{
                                TextField("Correo electrónico", text: $loginHomeViewModel.email)
                                    .modifier(body1())
                                Divider()
                                    .frame(height: 0.4)
                                    .padding(.horizontal, 30)
                                    .background(Color(LocalizedColor.grayIconTextField))
                                    .overlay(alignment: .topTrailing ){
                                        if loginHomeViewModel.isShowErrorEmail {
                                            Text("El correo electrónico no es válido")
                                                .modifier(messageUnderDivider())
                                                .foregroundColor(Color(LocalizedColor.errorValidation))
                                                .padding(.top, 5)
                                        }
                                        if registerWithEmailViewModel.showEmailExist {
                                            Text("El correo electrónico ya existe")
                                                .modifier(messageUnderDivider())
                                                .foregroundColor(Color(LocalizedColor.errorValidation))
                                                .padding(.top, 5)
                                        }
                                    }
                            }
                            VStack{
                                HStack{
                                    if loginHomeViewModel.isShowPassword {
                                        TextField("Contraseña", text: $loginHomeViewModel.password)
                                            .modifier(body1())
                                            .frame(height: 25)
                                    } else {
                                        SecureField("Contraseña", text: $loginHomeViewModel.password)
                                            .modifier(body1())
                                            .frame(height: 25)
                                    }
                                    Button {
                                        loginHomeViewModel.isShowPassword.toggle()
                                    } label: {
                                        Image(systemName: loginHomeViewModel.isShowPassword ? LocalizedImage.eye : LocalizedImage.eyeSlash)
                                            .foregroundColor(Color(LocalizedColor.grayIconTextField))
                                    }
                                }

                                Divider()
                                    .frame(height: 0.4)
                                    .padding(.horizontal, 30)
                                    .background(Color(LocalizedColor.grayIconTextField))
                                    .overlay(alignment: .topTrailing ){
                                        if loginHomeViewModel.isShowErrorPassword {
                                            Text("La contraseña debe tener al menos 8 caracteres")
                                                .modifier(messageUnderDivider())
                                                .foregroundColor(Color(LocalizedColor.errorValidation))
                                                .padding(.top, 5)
                                        }
                                    }
                            }
                            HStack{
                                Spacer()
                                Button {
                                    // Iniciar con transición fade la pantalla de recuperar contraseña
                                    withTransaction(Transaction.init(animation: .easeIn)) {
                                        loginHomeViewModel.isForgotPassword = true
                                    }
                                } label: {
                                    Text("¿Olvidaste la contraseña?")
                                        .modifier(caption())
                                }
                            }
                        }

                        // Botones
                        VStack (spacing: 20){
                            Button {
                                let loginData = LoginRequestModel(email: loginHomeViewModel.email, password: loginHomeViewModel.password)
                                self.hideKeyboard()
                                Task{
                                    if loginHomeViewModel.isValidateForm() {
                                        await loginHomeViewModel.loginRequest(loginData: loginData)
                                        validateResponseLogin()
                                    }
                                }
                            } label: {
                                Text("Iniciar sesión")
                                    .modifier(h5(color: .white))
                            }
                            .buttonStandarDesignLogin()

                            Text("o")
                                .modifier(body1())

                            VStack{
                                Button {
                                    registerWithEmailViewModel.showRegisterWithEmailView = true
                                } label: {
                                    ButtonLoginRegister(icon: LocalizedImage.email, tittleButton: "Registrarse con email", typeButton: .system)
                                }
                                Button {
                                    print("Registrarse con Google")
                                } label: {
                                    ButtonLoginRegister(icon: LocalizedImage.google, tittleButton: "Registrarse con Google", typeButton: .local)
                                }
                                .sheet(isPresented: $registerWithEmailViewModel.showRegisterWithEmailView, onDismiss: {}) {
                                    RegisterWithEmailView()
                                        .environmentObject(registerWithEmailViewModel)
                                }
                            }
                        }
                        // Condiciones
                        Button {
                            loginHomeViewModel.isShowTermsOfUse = true
                        } label: {
                            Text("Al iniciar sesión con tu cuenta de Google, aceptas nuestros términos. Obtén más informacion sobre nuestros términos ") +
                            Text("aquí").bold()
                        }
                        .modifier(caption())
                        .fullScreenCover(isPresented: $loginHomeViewModel.isShowTermsOfUse, onDismiss: {
                        }){
                            TermsOfUse(isShowTermsOfUse: $loginHomeViewModel.isShowTermsOfUse)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, Constants.paddingLoginHome)
                }
            }
            .onTapGesture(perform: {
                self.hideKeyboard()
            })
            .onChange(of: loginHomeViewModel.stateLogin) { _ in
                validateResponseLogin()
            }

            if loginHomeViewModel.isForgotPassword {
                ZStack{
                    Rectangle()
                        .foregroundColor(Color(LocalizedColor.grayTransparent))
                        .ignoresSafeArea()
                    EmptyView()
                        .textFieldAlert(isPresented: $loginHomeViewModel.isForgotPassword, title: "Restablecer la contraseña", message:Constants.textRestoreEmail, text: $loginHomeViewModel.emailRestore, placeholder: "Correo electrónico", action: { text in
                            print(text)
                        })
                }
            }
            if loginHomeViewModel.isShowLoading {
                ProgressView("").scaleEffect(1.2)
            }
        }
    }

    func validateResponseLogin(){
        switch loginHomeViewModel.stateLogin {
        case .success:
            withTransaction(Transaction.init(animation: .easeIn)) {
                routingViewModel.view = .mainScreenView
            }
        case .isNotRegister:
            withTransaction(Transaction.init(animation: .easeIn)) {
                routingViewModel.view = .registerForm
            }
        case .isNotVerified:
            print("El usuario no está verificado")
        case .invalidCredentials:
            popupViewModel.popupBasic(titlePopup: "El correo o la contraseña son incorrectos", titleButton: "Aceptar") { print("Credenciales inválidas") }
        case .emailNotVerified:
            popupViewModel.popupBasic(titlePopup: "Cuenta no verificada. Revisa el email que te enviamos", titleButton: "Aceptar") { print("El correo no está verificado") }
        }
    }
}

struct LoginHomeView_Previews: PreviewProvider {
    static var previews: some View {
        LoginHomeView()
            .environmentObject(RoutingViewModel())
            .environmentObject(LoginHomeViewModel())
            .environmentObject(PopupViewModel())
    }
}
