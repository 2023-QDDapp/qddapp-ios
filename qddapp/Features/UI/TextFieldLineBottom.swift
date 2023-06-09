//
//  TextFieldLineBottom.swift
//  qddapp
//
//  Created by gabatx on 21/5/23.
//

import SwiftUI

struct TextFieldLineBottom: View {

    @Binding var name: String
    var placeHolder: String

    init(placeHolder: String, name: Binding<String>) {
        self.placeHolder = placeHolder
        self._name = name
    }

    var body: some View {
        VStack{
            TextField(placeHolder, text: $name)
                .modifier(body1())
            Divider()
                .frame(height: 0.4)
                .background(Color(LocalizedColor.grayIconTextField))
        }
    }
}

struct TextFieldLineBottom_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldLineBottom(placeHolder: "Introduce tu nombre", name: .constant(""))
    }
}
