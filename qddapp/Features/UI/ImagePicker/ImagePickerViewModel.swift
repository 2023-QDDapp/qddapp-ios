//
//  ImagePickerViewModel.swift
//  qddapp
//
//  Created by gabatx on 28/5/23.
//

import Foundation
import SwiftUI

class ImagePickerViewModel: ObservableObject {
    
    @Published var image: Image = Image(Constants.imageEventTemplate) // Imagen que nos permite mostrar la imagen seleccionada
    @Published var imageData : Data = .init(capacity: 0) // Almacena la imagen seleccionada
    @Published var showImagePicker: Bool = false // Permite mostrar el ImagePicker
    @Published var showAlertCameraOrGallery = false
    @Published var isShowErrorPhotoAvatar = false
    @Published var source : UIImagePickerController.SourceType = .camera


    func loadImage(imageData: Data) {
        if imageData.count != 0 {
            image = Image(uiImage: UIImage(data: imageData)!)
        }
    }

}
