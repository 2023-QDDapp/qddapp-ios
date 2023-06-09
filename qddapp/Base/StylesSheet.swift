//
//  StylesSheet.swift
//  qddapp
//
//  Created by gabatx on 18/5/23.
//

import SwiftUI

extension Image {
    func imageStyle(color: Color = .white) -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 150, height: 150)
            .clipShape(Circle())
            .clipped()
            .overlay() {
                ZStack{
                    Image(systemName: "camera.fill")
                        .foregroundColor(.gray)
                        .offset(y: 60)
                    // Borde
                    RoundedRectangle(cornerRadius: 100)
                        .stroke(color, lineWidth:4)
                    
                }
            }
    }

    func styleBasicImageLogo(color: Color = Color("primary")) -> some View {
        self
            .resizable()
            .renderingMode(.template)
            .scaledToFit()
            .foregroundColor(color)
    }

    func styleIconSVG() -> some View {
        self
            .resizable()
            .scaledToFit()
    }
}

extension Text {
    func buttonStandarDesign(color: Color = Color("secondary"), padding: CGFloat = 18, infiniteWidth: Bool = true) -> some View {
           self
               .modifier(body1(color: .white))
               .frame(maxWidth: infiniteWidth ? .infinity : nil)
               .padding(padding)
               .background(color)
               .foregroundColor(.white)
               .cornerRadius(10)
       }

    func buttonStandarNotification(color: Color = Color("primary")) -> some View {
        self
            .modifier(body1(color: .white))
            .frame(width: UIScreen.main.bounds.width / 2 - 20)
            .padding(.vertical, 10)
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}

extension Button {
    func buttonStandarDesignLogin(color: Color = Color("primary")) -> some View {
        self
            .modifier(body1(color: .white))
            .frame(maxWidth: .infinity)
            .padding()
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(50)
    }
}

extension View {
    public func textFieldAlert(
        isPresented: Binding<Bool>,
        title: String,
        message: String,
        text: Binding<String>,
        placeholder: String = "",
        action: @escaping (String) -> Void
    ) -> some View {
        self.modifier(TextFieldAlert(isPresented: isPresented, title: title, message: message, text: text, placeholder: placeholder, action: action))
    }
}

extension Divider {
    public func lineBottom(color: Color = Color("grayIconTextField")) -> some View {
        self
            .frame(height: 0.4)
            .background(color)
    }
}

// Borde a una vista
extension View {
    public func borderStyle(color: Color = Color("primary")) -> some View {
        self
            .padding(10)
            .overlay(
                RoundedRectangle(cornerRadius: Constants.cornerRadius)
                    .stroke(color, lineWidth: Constants.lineWidth)
            )
    }
}
