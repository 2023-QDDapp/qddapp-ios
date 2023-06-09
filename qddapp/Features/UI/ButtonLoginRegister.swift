//
//  ButtonLoginRegister.swift
//  qddapp
//
//  Created by gabatx on 19/5/23.
//

import SwiftUI

enum TypeImageButtonLogin {
    case system
    case local
}

struct ButtonLoginRegister: View {


    var icon: String
    var tittleButton: String
    var typeButton: TypeImageButtonLogin

    init(icon: String, tittleButton: String, typeButton: TypeImageButtonLogin) {
        self.icon = icon
        self.tittleButton = tittleButton
        self.typeButton = typeButton
    }

    var body: some View {

        ZStack(alignment: .center) {
            HStack{
                switch typeButton {
                case .local:
                    Image(icon)
                            .styleIconSVG()
                            .frame(width: 18)
                            .padding(.leading, 10)
                case .system:
                    Image(systemName: icon)
                            .styleIconSVG()
                            .foregroundColor(Color(LocalizedColor.textDark))
                            .frame(width: 18)
                            .padding(.leading, 10)
                }
                Spacer()
            }
            Text(tittleButton)
                    .modifier(body1())
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 50)
                .stroke(Color(LocalizedColor.grayIconTextField), lineWidth: 0.5)
        )

    }
}

struct ButtonLoginRegister_Previews: PreviewProvider {
    static var previews: some View {
        ButtonLoginRegister(icon: LocalizedImage.google, tittleButton: "Regístrate con Google", typeButton: .local)
    }
}
