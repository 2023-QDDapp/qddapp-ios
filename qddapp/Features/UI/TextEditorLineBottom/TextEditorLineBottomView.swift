//
//  TextEditorLineBottomView.swift
//  qddapp
//
//  Created by gabatx on 28/5/23.
//

import SwiftUI

struct TextEditorLineBottomView: View {

    @Binding var descriptionUser:String
    @StateObject var textEditorLineBottomViewModel = TextEditorLineBottomViewModel()
    @State var containerHeight: CGFloat = 0
    let maxCharactersName = 200

    var body: some View {

        VStack (spacing: 0){
            AutoSizingTF(hint: textEditorLineBottomViewModel.placeholderAboutMe, text: $descriptionUser.max(maxCharactersName), containerHeight: $containerHeight, onEnd: {
                // Acción cuando el teclado está cerrado
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            })
            // Altura máxima
            .frame(height: containerHeight <= 180 ? containerHeight : 180)
            .background(Color.white)
            .cornerRadius(10)
            Divider()
                .lineBottom(color: Color(LocalizedColor.grayTextField))
                .overlay(alignment: .center){
                    if textEditorLineBottomViewModel.isShowErrorDescriptionAboutMe {
                        Text("Debe tener entre 100 y 200 caracteres")
                            .foregroundColor(Color(LocalizedColor.grayTextField))
                            .modifier(messageUnderDivider())
                            .padding(.top, 20)
                    }
                }
                .overlay(alignment: .trailing){
                    let sizeText = descriptionUser.count
                    let color = sizeText == 0 ? Color(LocalizedColor.textDark) :
                                sizeText > 0 && sizeText < 100 ? Color(LocalizedColor.errorValidation) : Color(LocalizedColor.textDark)
                    HStack{
                        Text("\(sizeText)/").foregroundColor(color) +
                        Text("200")
                    }
                    .padding(.top, 20)
                    .modifier(messageUnderDivider(color: Color(LocalizedColor.textDark)))
                }
                .onChange(of: descriptionUser.count, perform: { count in
                    if count >= 100 {
                        textEditorLineBottomViewModel.isShowErrorDescriptionAboutMe = false
                    }
                })
        }
        .padding(.top, 7)
        .onTapGesture {
            self.hideKeyboard()
        }
    }
}

struct TextEditorLineBottomView_Previews: PreviewProvider {
    static var previews: some View {
        TextEditorLineBottomView(descriptionUser: .constant(""))
    }
}
