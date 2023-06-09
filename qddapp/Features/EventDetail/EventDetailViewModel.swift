//
//  EventDetailViewModel.swift
//  qddapp
//
//  Created by gabatx on 24/4/23.
//

import Foundation
import SwiftUI

@MainActor
class EventDetailViewModel: ObservableObject{

    var repository: EventDetailRepositoryProtocol = EventDetailRepositoryApiRest()

    @Published var isLoading = false
    @Published var isLoadingRequestRelationship = false
    @Published var isLoadingJoinEvent = false
    @Published var event: EventDetailModel = DateFake.event
    @Published var isUserLogin = false
    @Published var state: EventUserRelationModel = .noRelation

    // Propiedades del botón
    @Published var isButtonEnabled = true
    @Published var buttonTitle = ""
    @Published var buttonColor = Color("primary")
    @Published var buttonTextColor = Color(.white)

    // Relación del usuario con el evento
    @Published var messagePopup = ""

    func getEventById(id: Int) async {
        isLoading = true
        var event = await repository.getEventById(id: id)
        // Mapea el resultado y si las urls de las imagenes no tienen el protocolo http se lo añade para que se puedan cargar
        event.photoEvent = Constants.validateUrlImage(url: event.photoEvent, urlBase: Constants.urlBaseImage)
        event.photoOrganiser = Constants.validateUrlImage(url: event.photoOrganiser, urlBase: Constants.urlBaseImage)
        event.participants = event.participants.map{ participant in
            var participant = participant
            participant.photo = Constants.validateUrlImage(url: participant.photo, urlBase: Constants.urlBaseImage)
            return participant
        }
        self.event = event
        isLoading = false
    }

    func validateIfIsUserLogin(idUser: Int){
        isUserLogin = idUser == Int(UserDefaultsManager.shared.userID!)!
    }

    func getEventToUserRelationship(idEvent: Int) async {
        isLoadingRequestRelationship = true
        let idEventBody = RequestIdBodyModel(id: idEvent)

        do {
            let result: EventUserRelationModel = try await repository.getEventToUserRelationship(idEvent: idEventBody)
            print(result)
            switch result {
            case .accepted:
                state = .accepted
            case .pending:
                state = .pending
            case .organizer:
                state = .organizer
            case .noRelation:
                state = .noRelation
            case .eventFinished:
                state = .eventFinished
            case .leaveReviewsAssistant:
                state = .leaveReviewsAssistant
            case .leaveReviewOrganizer:
                state = .leaveReviewOrganizer
            }
            // Estados que deberían venir del backend pero que estoy simulando en el frontend
            if (state == .noRelation || state == .pending) && event.dateEnd.stringToDate() ?? Date() < Date() {
                state = .eventFinished
            } else if state == .accepted && event.dateEnd.stringToDate() ?? Date() < Date() {
                state = .leaveReviewsAssistant
            } else if state == .organizer && event.dateEnd.stringToDate() ?? Date() < Date() {
                state = .leaveReviewOrganizer
            }
            renderUIButton()
            print("relación:", state)
        } catch {
            print("error:", error.localizedDescription)
        }
        isLoadingRequestRelationship = false
    }

    // MARK: - Acciones del botón
    // Función que dependiendo del estado muestra un botón u otro
    func renderUIButton() {
        switch state {
        case .accepted:
            buttonTitle = "Cancelar asistencia"
            buttonColor = Color(LocalizedColor.primary)
            buttonTextColor = Color(.white)
        case .pending:
            buttonTitle = "Cancelar solicitud"
            buttonColor = Color(LocalizedColor.graySeparator)
            buttonTextColor = Color(.white)
        case .organizer:
            buttonTitle = "Cancelar evento"
            buttonColor = Color(LocalizedColor.errorValidation)
            buttonTextColor = Color(.white)
        case .noRelation:
            buttonTitle = "Solicitar unirse"
            buttonColor = Color(LocalizedColor.secondary)
            buttonTextColor = Color(.white)
        case .eventFinished:
            buttonTitle = "Evento finalizado"
            buttonColor = Color(LocalizedColor.graySeparator)
            buttonTextColor = Color(.white)
        case .leaveReviewsAssistant:
            buttonTitle = "Reseña a organizador"
            buttonColor = Color(LocalizedColor.primary)
            buttonTextColor = Color(.white)
        case .leaveReviewOrganizer:
            buttonTitle = "Reseñas a asistentes"
            buttonColor = Color(LocalizedColor.primary)
            buttonTextColor = Color(.white)
        }
    }

    // Función que dependiendo del estado realiza una acción u otra
    func actionButtonEvent() async {
        switch state {
        case .accepted:
            await cancelAssistance()
        case .pending:
            await cancelEvent()
        case .organizer:
            await editEvent()
        case .noRelation:
            await assist()
        case .eventFinished:
            eventFinished()
        case .leaveReviewsAssistant:
            await leaveReview()
        case .leaveReviewOrganizer:
            await leaveReview()
        }
    }

    // MARK: - Acciones del botón
    private func assist() async {
        await requestToJoinTheEvent()
    }

    private func editEvent() async{
        print("editEvent")
    }

    private func cancelEvent() async {
        print("cancelEvent")
    }

    private func cancelAssistance() async{
        print("cancelAssistance")
    }

    private func leaveReview() async {
        print("leaveReview")
    }

    private func eventFinished() {
        print("eventFinished")
    }


    func requestToJoinTheEvent() async {
        isLoadingJoinEvent = true
        let idEventBody = RequestIdBodyModel(id: event.id)

        let result: ResponseJoinEventModel = await repository.requestToJoinTheEvent(idEvent: idEventBody)
        switch result.message {
        case .joinEvent:
            messagePopup = ResponseJoinEvent.joinEvent.rawValue
            state = .accepted
        case .pendingResponse:
            messagePopup = ResponseJoinEvent.pendingResponse.rawValue
            state = .pending
        case .alreadyJoined:
            messagePopup = ResponseJoinEvent.alreadyJoined.rawValue
            state = .accepted
        }
        renderUIButton()
        isLoadingJoinEvent = false
    }

    func cancelAssistanceToEvent() async {
        isLoadingJoinEvent = true
        let idEventBody = RequestIdBodyModel(id: event.id)
        //let result: ResponseJoinEventModel = await repository.cancelAssistanceToEvent(idEvent: idEventBody)



        renderUIButton()
        isLoadingJoinEvent = false
    }

}
