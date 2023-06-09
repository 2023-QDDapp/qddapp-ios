//
//  SetNameView.swift
//  qddapp
//
//  Created by gabatx on 21/5/23.
//

import SwiftUI

struct SetNameView: View {

    @EnvironmentObject var registerFormViewModel: RegisterFormViewModel
    let maxCharactersName = 20
    let minCharactersName = 5
    var isEditUser = false

    init(isEditUser: Bool = false) {
        self.isEditUser = isEditUser
    }

    var body: some View {
        VStack(spacing: 20){
            if !isEditUser {
                Text("¿Cómo te llamas?")
                    .modifier(h3(color: (Color(LocalizedColor.secondary))))
                Text("Este será tu nombre de usuario, recuerda que no podrás cambiarlo después")
                    .modifier(body1())
                    .multilineTextAlignment(.center)
            }
            VStack{
                TextField("Introduce tu nombre", text: $registerFormViewModel.name.max(maxCharactersName), onEditingChanged: { (isChanged) in
                    if !isChanged {
                        registerFormViewModel.checkName()
                    }
                })
                    .modifier(body1())
                    .multilineTextAlignment(isEditUser ? .leading :.center)
                
                Divider()
                    .lineBottom()
                    .overlay(alignment: .center){
                        if registerFormViewModel.showNameError {
                            Text("Debe tener entre \(minCharactersName) y \(maxCharactersName) caracteres")
                                .modifier(messageUnderDivider())
                                .padding(.top, 20)
                        }
                    }
                    .overlay(alignment: .trailing){
                        let sizeText = registerFormViewModel.name.count
                        let color = sizeText == 0 ? Color(LocalizedColor.textDark) :
                                    sizeText > 0 && sizeText < minCharactersName ? Color(LocalizedColor.errorValidation) : Color(LocalizedColor.textDark)
                        HStack{
                            Text("\(sizeText)/").foregroundColor(color) +
                            Text("\(maxCharactersName)")
                        }
                        .padding(.top, 20)
                        .modifier(messageUnderDivider(color: Color(LocalizedColor.textDark)))
                    }
            }
                .padding(.horizontal, 8)
        }
        .padding(.horizontal, isEditUser ? 0 : Constants.paddingLoginHome)
        .onDisappear(){
            registerFormViewModel.checkName()
        }
    }
}

struct SetNameView_Previews: PreviewProvider {
    static var previews: some View {
        SetNameView()
            .environmentObject(RegisterFormViewModel())
    }
}
