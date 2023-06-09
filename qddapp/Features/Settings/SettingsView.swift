//
//  SettingsView.swift
//  qddapp
//
//  Created by gabatx on 14/5/23.
//

import SwiftUI

struct SettingsView: View {

    @EnvironmentObject var routingViewModel: RoutingViewModel
    @EnvironmentObject var popupViewModel: PopupViewModel
    @EnvironmentObject var userDetailViewModel: UserDetailViewModel
    @StateObject var settingsViewModel = SettingsViewModel()
    @AppStorage("notificationsEnabled") var notificationsEnabled = false


    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Form {
                    Section(header: Text("Usuarios") .modifier(body2())){
                        NavigationLink {
                        ProfileEditView()
                                .navigationTitle("Editar perfil")
                        } label: {
                            HStack(spacing: 12){
                                Rectangle()
                                    .foregroundColor(Color(LocalizedColor.primary))
                                    .frame(width: 30, height: 30)
                                    .cornerRadius(5)
                                    .overlay(alignment: .center) {
                                        Image(systemName: "person.fill")
                                            .foregroundColor(.white)
                                    }
                                Text("Editar perfil")
                                Spacer()
                            }
                        }

                        NavigationLink {
                            FollowedUsersListView()
                        } label: {
                            HStack(spacing: 12){
                                Rectangle()
                                    .foregroundColor(Color(LocalizedColor.secondary))
                                    .frame(width: 30, height: 30)
                                    .cornerRadius(5)
                                    .overlay(alignment: .center) {
                                        Image(systemName: "person.3.fill")
                                            .padding(1)
                                            .foregroundColor(.white)
                                    }
                                Text("Usuarios que sigues")
                                Spacer()
                            }
                        }
                    }

                    Section(header: Text("Sistema") .modifier(body2())){
                        HStack(spacing: 12){
                            Rectangle()
                                .foregroundColor(.yellow)
                                .frame(width: 30, height: 30)
                                .cornerRadius(5)
                                .overlay(alignment: .center) {
                                    Image(systemName: "bell.fill")
                                        .foregroundColor(.white)
                                }
                            Text("Activar notificaciones")
                                .modifier(body1())
                                .foregroundColor(Color(LocalizedColor.textDark))
                            Spacer()
                            Toggle("", isOn: $notificationsEnabled)
                                .modifier(body1())
                                .foregroundColor(Color(LocalizedColor.textDark))
                                .labelsHidden()
                                .toggleStyle(SwitchToggleStyle(tint: Color(LocalizedColor.primary)))
                        }

                        NavigationLink {
                        } label: {
                            HStack(spacing: 12){
                                Rectangle()
                                    .foregroundColor(.blue)
                                    .frame(width: 30, height: 30)
                                    .cornerRadius(5)
                                    .overlay(alignment: .center) {
                                        Image(systemName: "location.fill")
                                            .padding(1)
                                            .foregroundColor(.white)
                                    }
                                Text("Cambiar ubicación")
                                Spacer()
                            }
                        }
                        .onTapGesture {
                            // Abrimos ajustes de localización. Da warning (Receive failed with error "Software caused connection abort")
                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                        }
                    }

                    Section(header: Text("Eventos") .modifier(body2())){
                        NavigationLink {
                            EventsHeldView()
                        } label: {
                            HStack(spacing: 12){
                                Rectangle()
                                    .foregroundColor(.orange)
                                    .frame(width: 30, height: 30)
                                    .cornerRadius(5)
                                    .overlay(alignment: .center) {
                                        Image(systemName: "sun.max")
                                            .foregroundColor(.white)
                                    }
                                Text("Eventos realizados")
                                Spacer()
                            }
                        }
                    }

                }
                .background(Color(uiColor: .systemGray6))
                .navigationTitle("Ajustes")


            }
            .overlay(alignment: .bottom) {
                HStack(alignment: .center){
                    Button{
                        popupViewModel.popupBasic(titlePopup: "¿Estas seguro?, se eliminará tu cuenta", titleButton: "Si, estoy seguro") {

                            UserDefaultsManager.shared.isUserLoggedIn = false
                            withAnimation(.easeIn) {
                                routingViewModel.view = .loginHomeView
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                Task{
                                    await settingsViewModel.deleteUser()
                                }
                            }
                        }

                    } label: {
                        Text("Eliminar cuenta")
                            .underline()
                            .foregroundColor(.red)
                            .modifier(body1())
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 30)
            }

            if settingsViewModel.isLoadingDeleteUserAccount {
                ProgressView()
            }
        }
        .navigationBarItems(trailing: HStack {
            Text("Cerrar sesión")
                .bold()
                .modifier(messageUnderDivider(color: Color(LocalizedColor.primary)))
            Image(systemName: "rectangle.portrait.and.arrow.right")
        }
            .foregroundColor(Color(LocalizedColor.primary))
            .onTapGesture {
                popupViewModel.popupBasic(titlePopup: "¿Cerrar sesión?, volverás a la página de login", titleButton: "Cerrar sesión") {
                    UserDefaultsManager.shared.isUserLoggedIn = false
                    withAnimation(.easeIn) {
                        routingViewModel.view = .loginHomeView
                    }
                        settingsViewModel.closeSession()
                }
            }
        )
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(RoutingViewModel())
            .environmentObject(PopupViewModel())
            .environmentObject(UserDetailViewModel())
    }
}
