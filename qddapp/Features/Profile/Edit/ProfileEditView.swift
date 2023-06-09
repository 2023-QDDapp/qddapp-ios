//
//  ProfileEditView.swift
//  qddapp
//
//  Created by gabatx on 28/5/23.
//

import SwiftUI
import WrappingHStack

struct ProfileEditView: View {

    @EnvironmentObject var popupViewModel: PopupViewModel
    @StateObject var registerFormViewModel = RegisterFormViewModel()
    @StateObject var categoriesViewModel = CategoriesViewModel()
    @State var containerHeight: CGFloat = 0
    let maxCharactersName = 20
    let minCharactersName = 5
    let maxCharactersDescription = 200
    
    var body: some View {
        ScrollView {

            // --- NOMBRE: ---
            VStack (spacing: 10){
                Text("Foto")
                    .modifier(body1())

                SetPhotoAvatarView(isEditUser: true)
                    .environmentObject(registerFormViewModel)
                    .padding(.bottom, 8)

                SetNameView(isEditUser: true)
                    .environmentObject(registerFormViewModel)
                    .padding(.vertical, 8)
                    .padding(.horizontal, -8)

                SetPhoneView(isEditUser: true)
                    .environmentObject(registerFormViewModel)
                    .padding(.vertical, 8)

                SetAboutMeView(isEditUser: true)
                    .environmentObject(registerFormViewModel)
                    .padding(.vertical, 4)

                // --- CATEGORIAS: ---
                Button {
                    categoriesViewModel.showSelectAllCategoriesView = true
                } label: {
                    Text("Selecciona tus categorias")
                        .buttonStandarDesign(color: Color(LocalizedColor.primary), padding: 10, infiniteWidth: false)
                }
                .padding(.top, 40)
                .sheet(isPresented: $categoriesViewModel.showSelectAllCategoriesView) {
                    CategoriesProfileView(categoriesViewModel: categoriesViewModel)
                }
                
                VStack(alignment: .center) {
                    ForEach(categoriesViewModel.categoriesSelected) {category in
                        CategoryItem(background: Color(LocalizedColor.secondary), name: category.name)
                    }
                }
                .padding(.top)

                Button {
                    popupViewModel.popupBasic(titlePopup: "¿Deseas actualizar el perfíl?", titleButton: "Actualizar") {
                        Task {
                            if await registerFormViewModel.checkFieldsEditUser(idsInterests: categoriesViewModel.idCategoriesSelected) {
                                if await registerFormViewModel.updateProfileData(idsInterests: categoriesViewModel.idCategoriesSelected) {
                                    popupViewModel.popupBasic(titlePopup: "Perfil actualizado", titleButton: "Aceptar") { }
                                } else {
                                    popupViewModel.popupBasic(titlePopup: "Error al actualizar el perfil", titleButton: "Aceptar") { }
                                }
                            } else {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    popupViewModel.popupBasic(titlePopup: "Hay campos incorrectos", titleButton: "Aceptar") {
                                    }
                                }
                            }
                        }
                    }
                } label: {
                    Text("Aceptar cambios")
                        .buttonStandarDesign(color: Color(LocalizedColor.primary))
                        .padding(.top, 20)
                }
                Spacer()
            }
            .padding(Constants.paddingLoginHome)
        }
        .onAppear(){
            Task{
                await registerFormViewModel.getProfileData(idUser: Int(UserDefaultsManager.shared.userID!)!)
                categoriesViewModel.categoriesSelected = registerFormViewModel.profileData.interests
            }
        }
        // Cuando se descarga la imagen y se asigna el valor, se carga en el imagePickerViewModel
        .onChange(of: registerFormViewModel.imageData) { value in
            registerFormViewModel.loadImage(imageData: value)
        }
        .onChange(of: registerFormViewModel.profileData) { newProfileData in
            categoriesViewModel.idCategoriesSelected = newProfileData.interests.map(\.id)
        }
        .onTapGesture {
            self.hideKeyboard()
        }
        .redacted(reason: registerFormViewModel.isLoading ? .placeholder : [])
    }
}

struct ProfileEditView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileEditView()
            .environmentObject(RegisterFormViewModel())
            .environmentObject(PopupViewModel())
    }
}
