//
//  SetAboutMeView.swift
//  qddapp
//
//  Created by gabatx on 22/5/23.
//

import SwiftUI

struct SetAboutMeView: View {

    @EnvironmentObject var registerFormViewModel: RegisterFormViewModel
    @State var containerHeight: CGFloat = 0
    let maxCharacters = 200
    let minCharacters = 30
    var isEditUser = false

    init(isEditUser: Bool = false) {
        self.isEditUser = isEditUser
    }
    
    var body: some View {
        VStack(spacing: 20){

            if !isEditUser {
                Text("Cuéntanos un poco sobre ti")
                    .modifier(h3(color: (Color(LocalizedColor.secondary))))
                    .multilineTextAlignment(.center)
                Text("Escribe una breve biografía para que los demás usuarios puedan conocerte.")
                    .modifier(body1())
                    .multilineTextAlignment(.center)
            }

            VStack (spacing: 0){

                AutoSizingTF(hint: registerFormViewModel.placeholderAboutMe, text: $registerFormViewModel.descriptionUser.max(maxCharacters), containerHeight: $containerHeight, onEnd: {
                    // Acción cuando el teclado está cerrado
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                })
                // Altura máxima
                .frame(height: containerHeight <= 180 ? containerHeight : 180)
                .background(Color.white)
                .cornerRadius(10)
                Divider()
                    .lineBottom(color: registerFormViewModel.showDescriptionError ? .red : Color(LocalizedColor.grayIconTextField))
                    .overlay(alignment: .center){
                        if registerFormViewModel.showDescriptionError {
                            Text("Debes escribir entre \(minCharacters) y \(maxCharacters) caracteres")
                                .modifier(messageUnderDivider())
                                .padding(.top, 20)
                        }
                    }
                    .overlay(alignment: .trailing){
                        let sizeText = registerFormViewModel.descriptionUser.count
                        let color = sizeText == 0 ? Color(LocalizedColor.textDark) :
                                    sizeText > 0 && sizeText < minCharacters ? Color(LocalizedColor.errorValidation) : Color(LocalizedColor.textDark)
                        HStack{
                            Text("\(sizeText)/").foregroundColor(color) +
                            Text("200")
                        }
                        .padding(.top, 20)
                        .modifier(messageUnderDivider(color: Color(LocalizedColor.textDark)))
                    }
            }
        }
        .onChange(of: registerFormViewModel.descriptionUser.count, perform: { count in
            if count >= minCharacters {
                registerFormViewModel.showDescriptionError = false
            }
        })
        .padding(.horizontal, isEditUser ? 0 : Constants.paddingLoginHome)
        .onDisappear(){
            registerFormViewModel.checkDescription()
        }
    }
}

struct SetAboutMeView_Previews: PreviewProvider {
    static var previews: some View {
        SetAboutMeView()
            .environmentObject(RegisterFormViewModel())
    }
}
