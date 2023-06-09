//
//  SetPhotoAvatarView.swift
//  qddapp
//
//  Created by gabatx on 21/5/23.
//

import SwiftUI

struct SetPhotoAvatarView: View {

    @EnvironmentObject var registerFormViewModel: RegisterFormViewModel
    var isEditUser = false

    init(isEditUser: Bool = false) {
        self.isEditUser = isEditUser
    }

    var body: some View {
        VStack(spacing: 20){
            if !isEditUser{
                Text("Añade una foto o avatar")
                    .modifier(h3(color: (Color(LocalizedColor.secondary))))
                    .multilineTextAlignment(.center)
                Text("Necesitamos ponerle cara a tu perfil, además, genera más confianza en los usuarios.")
                    .modifier(body1())
                    .multilineTextAlignment(.center)
            }
            ZStack{
                registerFormViewModel.profileImage
                    .imageStyle(color: registerFormViewModel.showAvatarError ? .red : .white)
                    .onTapGesture {
                        registerFormViewModel.showAlertCameraOrGallery = true
                    }
                    .actionSheet(isPresented: $registerFormViewModel.showAlertCameraOrGallery) {
                        ActionSheet(
                            title: Text("Añada una imagen"),
                            message: Text("Eliga entre las opciones disponibles"),
                            buttons: [
                                .default(Text("Galería"), action: {
                                    registerFormViewModel.source = .photoLibrary
                                    registerFormViewModel.showImagePicker.toggle()
                                }),
                                .default(Text("Cámara")) {
                                    registerFormViewModel.source = .camera
                                    registerFormViewModel.showImagePicker.toggle()
                                },
                                .destructive(Text("Cancelar"))])
                    }
                    // Cuando cambie el valor de inputImage, llamamos a la función loadImage() para mostrar la imagen seleccionada
                    .onChange(of: registerFormViewModel.imageData) { newValue in
                        registerFormViewModel.loadImage(imageData: newValue)
                        registerFormViewModel.checkAvatar()
                    }
                    // Mostramos el ImagePicker en un sheet cuando showImagePicker sea true
                    .fullScreenCover(isPresented: $registerFormViewModel.showImagePicker) {
                        ImagePicker(show: $registerFormViewModel.showImagePicker, image: $registerFormViewModel.imageData, source: registerFormViewModel.source)
                            .ignoresSafeArea()
                    }
            }
            if registerFormViewModel.showAvatarError {
                Text("Debes añadir una imagen")
                    .foregroundColor(.red)
                    .modifier(body1())
            }
        }
        .padding(.horizontal, isEditUser ? 0 : Constants.paddingLoginHome)
        .onDisappear(){
            registerFormViewModel.checkAvatar()
        }
    }
}

struct SetPhotoAvatarView_Previews: PreviewProvider {
    static var previews: some View {
        SetPhotoAvatarView()
            .environmentObject(RegisterFormViewModel())
    }
}
