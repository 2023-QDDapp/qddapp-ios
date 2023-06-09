//
//  ImagePicker.swift
//  qddapp
//
//  Created by gabatx on 18/5/23.
//

import Foundation
import SwiftUI

// Estructura que nos permite mostrar el ImagePicker
struct ImagePicker: UIViewControllerRepresentable {

    @Binding var show : Bool // Permite mostrar el ImagePicker
    @Binding var image : Data // Imagen que se selecciona
    var source : UIImagePickerController.SourceType // Origen de la imagen

    // Función que nos permite mostrar el ImagePicker
    func makeCoordinator() -> ImagePicker.Coordinator {
        return ImagePicker.Coordinator(conexion: self) //conexion nos permite acceder a las variables de ImagePicker
    }

    // Esta función se utiliza para crear el controlador de vista y configurarlo.
    func makeUIViewController(context: Context) -> some UIImagePickerController {
        let controller = UIImagePickerController() // Creamos el controlador de vista
        controller.sourceType = source // Le asignamos el origen
        controller.delegate = context.coordinator // Le asignamos el delegado, que es el Coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

        var conexion : ImagePicker // Variable que nos permite acceder al ImagePicker

        init(conexion: ImagePicker){
            self.conexion = conexion
        }

        // Función que se ejecuta cuando se cancela la selección de una imagen
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            print("Se ha cancelado")
            self.conexion.show.toggle() // Mostramos el ImagePicker
        }

        // Función que se ejecuta cuando se selecciona una imagen
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let image = info[.originalImage] as! UIImage // Obtenemos la imagen seleccionada
            let data = image.jpegData(compressionQuality: 0.100) // Convertimos la imagen a Data con una calidad del 10%
            self.conexion.image = data! // Asignamos la imagen seleccionada a la variable image del ImagePicker
            self.conexion.show.toggle() // Cerramos el ImagePicker
        }
    }
}

