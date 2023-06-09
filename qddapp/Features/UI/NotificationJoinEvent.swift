//
//  NotificationJoinEvent.swift
//  qddapp
//
//  Created by gabatx on 15/5/23.
//

import SwiftUI

struct NotificationJoinEvent: View {

    var photo: String

    init(photo: String) {
        self.photo = photo
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
                        Text("Pepe The Yayo ").bold() +
                        Text("quiere unirse a tu evento ") +
                        Text("\"fiesta en la playa\"")
                            .underline()
                            .bold()
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
                    Text("Aceptar solicitud")
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

struct NotificationJoinEventItem_Previews: PreviewProvider {
    static var previews: some View {
        let photoMock = "https://this-person-does-not-exist.com/img/avatar-gen11c3c22425531189b0bfb571fe9acd16.jpg"

        NotificationJoinEvent(photo: photoMock)
    }
}
