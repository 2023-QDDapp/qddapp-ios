//
//  NotificationsView.swift
//  qddapp
//
//  Created by gabatx on 15/5/23.
//

import SwiftUI

struct NotificationsView: View {

    let photoMock = "https://this-person-does-not-exist.com/img/avatar-gen11c3c22425531189b0bfb571fe9acd16.jpg"


    var body: some View {
        List{
            NavigationLink {
                EventsHeldView()
            } label: {
                Text("Pulsame")
            }

            NotificationChangeStatusEvent(photo: photoMock, userName: "Pedro Ramiréz", titleEvent: "jugar a la brisca")
                .listRowInsets(Constants.listRowInsets)
                .listRowBackground(Color.clear) // Eliminar el color de fondo al pulsar la celda
                .padding(.top, 20)
            NotificationChangeStatusEvent(photo: photoMock, userName: "Lorenzo Ordoñez", titleEvent: "partida de dardos")
                .listRowInsets(Constants.listRowInsets)
                .listRowBackground(Color.clear) // Eliminar el color de fondo al pulsar la celda
            NotificationJoinEvent(photo: photoMock)
                .listRowInsets(Constants.listRowInsets)
                .listRowBackground(Color.clear) // Eliminar el color de fondo al pulsar la celda
            NotificationChangeStatusEvent(photo: photoMock, userName: "JoseFina", titleEvent: "cocina con Josefina")
                .listRowInsets(Constants.listRowInsets)
                .listRowBackground(Color.clear) // Eliminar el color de fondo al pulsar la celda
            NotificationReviewUser(photo: photoMock, event: "Tirar chinas al pantano")
                .listRowInsets(Constants.listRowInsets)
                .listRowBackground(Color.clear) // Eliminar el color de fondo al pulsar la celda
            NotificationChangeStatusEvent(photo: photoMock, userName: "Paula Morena", titleEvent: "a bailar rumba")
                .listRowInsets(Constants.listRowInsets)
                .listRowBackground(Color.clear) // Eliminar el color de fondo al pulsar la celda
            NotificationChangeStatusEvent(photo: photoMock, userName: "Gustavo Pivotez", titleEvent: "al pan pan y al vino vino")
                .listRowInsets(Constants.listRowInsets)
                .listRowBackground(Color.clear) // Eliminar el color de fondo al pulsar la celda
            NotificationChangeStatusEvent(photo: photoMock, userName: "Lorenzo Ordoñez", titleEvent: "partida de dardos")
                .listRowInsets(Constants.listRowInsets)
                .listRowBackground(Color.clear) // Eliminar el color de fondo al pulsar la celda
            NotificationJoinEvent(photo: photoMock)
                .listRowInsets(Constants.listRowInsets)
                .listRowBackground(Color.clear) // Eliminar el color de fondo al pulsar la celda
        }
        .listStyle(.plain)// Elimina el color de fondo
        .navigationTitle("Notificaciones")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}
