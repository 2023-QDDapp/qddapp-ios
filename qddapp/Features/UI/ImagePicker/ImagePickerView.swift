//
//  ImagePickerView.swift
//  qddapp
//
//  Created by gabatx on 28/5/23.
//

import SwiftUI

struct ImagePickerView: View {

    @ObservedObject var imagePickerViewModel: ImagePickerViewModel

    var body: some View {

        ZStack{

            imagePickerViewModel.image
                .imageStyle(color: imagePickerViewModel.isShowErrorPhotoAvatar ? .red : .white)
                .onTapGesture {
                    imagePickerViewModel.showAlertCameraOrGallery = true
                }
                .actionSheet(isPresented: $imagePickerViewModel.showAlertCameraOrGallery) {
                    ActionSheet(
                        title: Text("Añada una imagen"),
                        message: Text("Eliga entre las opciones disponibles"),
                        buttons: [
                            .default(Text("Galería"), action: {
                                imagePickerViewModel.source = .photoLibrary
                                imagePickerViewModel.showImagePicker.toggle()
                            }),
                            .default(Text("Cámara")) {
                                imagePickerViewModel.source = .camera
                                imagePickerViewModel.showImagePicker.toggle()
                            },
                            .destructive(Text("Cancelar"))])
                }
                // Cuando cambie el valor de inputImage, llamamos a la función loadImage() para mostrar la imagen seleccionada
                .onChange(of: imagePickerViewModel.imageData) { newValue in imagePickerViewModel.loadImage(imageData: newValue) }
                // Mostramos el ImagePicker en un sheet cuando showImagePicker sea true
                .fullScreenCover(isPresented: $imagePickerViewModel.showImagePicker) {
                    ImagePicker(show: $imagePickerViewModel.showImagePicker,
                                image: $imagePickerViewModel.imageData,
                                source: imagePickerViewModel.source)
                        .ignoresSafeArea()
                }
        }
    }
}

struct ImagePickerView_Previews: PreviewProvider {
    static var previews: some View {
        ImagePickerView(imagePickerViewModel: ImagePickerViewModel())
    }
}
