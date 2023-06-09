//
//  TextEditorItem.swift
//  qddapp
//
//  Created by gabatx on 14/5/23.
//

import SwiftUI

struct TextEditorItem: View {

    @Binding var description: String
    @Binding var placeholder: String
    var height:CGFloat = 100

    var body: some View {
        ZStack (alignment: .topLeading){
            if description.isEmpty {
                        TextEditor(text:$placeholder)
                            .font(.body)
                            .foregroundColor(.gray)
                            .disabled(true)
                }
                TextEditor(text: $description)
                    .font(.body)
                    .opacity(description.isEmpty ? 0.25 : 1)
                    .frame(height: height)

        }
        .onTapGesture {
            if description == placeholder {
                self.description = ""
            }
        }
    }
}

struct TextEditorItem_Previews: PreviewProvider {
    static var previews: some View {
        TextEditorItem(description: .constant(""), placeholder: .constant("Escribe todo sobre el evento"))
    }
}
