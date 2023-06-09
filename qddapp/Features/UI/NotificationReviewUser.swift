//
//  NotificationReviewUser.swift
//  qddapp
//
//  Created by gabatx on 15/5/23.
//

import SwiftUI
import WrappingHStack

struct NotificationReviewUser: View {

    var photo: String
    var event: String

    init(photo: String, event: String) {
        self.photo = photo
        self.event = event
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
                        Text("Tu evento \"") +
                        Text("tirar chinas al pantano").underline().bold() +
                        Text("\" ") +
                        Text("terminó, ¿quieres dejar una reseña ") +
                        Text("los asistentes").bold().underline() +
                        Text("?")

                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)

                Button {
                    print("Aceptar solicitud")
                } label: {
                   Text("Dejar reseñas")
                        .buttonStandarNotification()
                }
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

struct NotificationReviewUser_Previews: PreviewProvider {
    static var previews: some View {
        let photoMock = "https://this-person-does-not-exist.com/img/avatar-gen11c3c22425531189b0bfb571fe9acd16.jpg"

        NotificationReviewUser(photo: photoMock, event: "Fiesta en la playa")
    }
}
