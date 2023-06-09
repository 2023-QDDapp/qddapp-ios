//
//  EventCreateViewModel.swift
//  qddapp
//
//  Created by gabatx on 14/5/23.
//

import Foundation
import UIKit
import SwiftUI

@MainActor
class EventCreateViewModel: ObservableObject {

    let repository: EventCreateRepositoryProtocol = EventCreateRepositoryApiRest()

    @Published var tittleEvent: String = ""
    @Published var descriptionEvent: String = ""
    @Published var currentDateStart: Date = Date()
    @Published var currentDateEnd: Date = Date()
    @Published var distanceCounter: Float = 200
    @Published var typeEvent = Constants.typeEventPublic
    @Published var isPresentedShowCatergoriesView = false
    @Published var isActiveNavigationtoMapFilterView = false
    @Published var isPresentedShowImagePicker = false
    @Published var isLoading = false
    @Published var isLoadingRequestCreateEvent = false

    // MARK: - Image Picker
    @Published var imageEvent: Image = Image(Constants.imageEventTemplate) // Imagen que nos permite mostrar la imagen seleccionada
    @Published var imageData : Data = .init(capacity: 0) // Almacena la imagen seleccionada
    @Published var showImagePicker: Bool = false // Permite mostrar el ImagePicker
    @Published var showAlertCameraOrGallery = false
    @Published var source : UIImagePickerController.SourceType = .camera

    // MARK: - Editar evento
    @Published var showEventCreateView = false

    func loadImage(){
        if imageData.count != 0 {
            imageEvent = Image(uiImage: UIImage(data: imageData)!)
        }
    }

    func requestToCreateEvent(data: EventCreateModel) async -> Bool{
        isLoadingRequestCreateEvent = true
        let result = await repository.requestToCreateEvent(data: data).message
        isLoadingRequestCreateEvent = false
        return result.contains("El evento ha sido creado correctamente")
    }
}
