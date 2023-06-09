//
//  NotificationChangeStatusEvent.swift
//  qddapp
//
//  Created by gabatx on 15/5/23.
//

import SwiftUI

struct NotificationChangeStatusEvent: View {

    var photo: String
    var userName: String
    var titleEvent: String

    init(photo: String, userName: String, titleEvent: String) {
        self.photo = photo
        self.userName = userName
        self.titleEvent = titleEvent
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {

            Button {
                print("Elimina la notificación")
            } label: {
                Image("cerrar")
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color(LocalizedColor.primary))
            }
            .padding(.trailing, 10)
            .padding(.top, 10)

            VStack {
                HStack(spacing: 15){
                    ImageRoundedItem(photo: photo, width: 60, height: 60)

                    HStack(spacing: 0){
                        Text("\(userName) ").bold() +
                        Text("canceló el evento ") +
                        Text("\"") +
                        Text("\(titleEvent)").underline().bold() +
                        Text("\"")

                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)


            }
            .frame(maxWidth: .infinity)
            .padding(.vertical)

            .overlay(
                       RoundedRectangle(cornerRadius: Constants.cornerRadius)
                           .stroke(Constants.borderColor, lineWidth: Constants.lineWidth)
                   )
        .cornerRadius(10)
        }
    }
}

struct NotificationChangeStatusEvent_Previews: PreviewProvider {
    static var previews: some View {
        let photoMock = "https://this-person-does-not-exist.com/img/avatar-gen11c3c22425531189b0bfb571fe9acd16.jpg"

        NotificationChangeStatusEvent(photo: photoMock, userName: "Patrica Munoz", titleEvent: "Fiesta en la playa")
    }
}
