//
//  PopupBasicItem.swift
//  qddapp
//
//  Created by gabatx on 31/5/23.
//

import SwiftUI

struct PopupBasicView: View {

    @Binding var show: Bool
    var tittlePopup: String
    var tittleButton: String
    var content: () -> Void

    init(show: Binding<Bool>, tittlePopup: String, tittleButton: String, content: @escaping () -> Void) {
        self._show = show
        self.tittlePopup = tittlePopup
        self.tittleButton = tittleButton
        self.content = content
    }

    var body: some View {
        // MARK: Lector de geometría para leer el marco del contenedor
        GeometryReader{ proxy in

            Color.primary
                .opacity(0.15)
                .ignoresSafeArea()
                .onTapGesture {
                    self.hideKeyboard()
                }

            let size = proxy.size

            ZStack(alignment: .topTrailing) {
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation {
                            show = false
                        }
                    }) {
                        Image("cerrar")
                            .styleIconSVG()
                            .frame(height: 22)
                    }
                    .padding(.top, 25)
                    .padding(.trailing, 15)
                }
                VStack (spacing: 40){
                    Spacer()
                    Image("logo")
                        .styleBasicImageLogo()
                        .frame(height: 70)
                    Text(tittlePopup)
                        .modifier(body1())
                        .multilineTextAlignment(.center)

                    Button {
                        content()
                    } label: {
                        Text(tittleButton)
                            .buttonStandarDesign(color: Color(LocalizedColor.primary))
                    }
                    Spacer()
                }
                .padding(.horizontal, Constants.paddinPopup)
            }
            .frame(width: size.width - Constants.paddinPopup, height: size.height / 2.5, alignment: .center)
            // Corner Radius
            .background(.white)
            .cornerRadius(15)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
    }
}

struct PopupBasicView_Previews: PreviewProvider {
    static var previews: some View {
        PopupBasicView(show: .constant(true), tittlePopup: "¿Estas Seguro de que quieres dejar de seguir a este usuario?", tittleButton: "Si, estoy seguro") {
            print("Dejo de seguir")
        }
    }
}
