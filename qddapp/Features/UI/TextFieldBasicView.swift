//
//  TextFieldBasicView.swift
//  qddapp
//
//  Created by gabatx on 14/5/23.
//

import SwiftUI

struct TextFieldBasicView: View {

    @Binding var inputText: String
    var placerHolder: String
    var colorButtonClean: Color
    var hasForegroundColor: Bool
    var hasPadding: Bool

    init(placerHolder: String, inputText: Binding<String>, colorButtonClean: Color, hasForegroundColor: Bool = true, hasPadding:Bool = true) {
        self.placerHolder = placerHolder
        self._inputText = inputText
        self.colorButtonClean = colorButtonClean
        self.hasForegroundColor = hasForegroundColor
        self.hasPadding = hasPadding
    }

    var body: some View {
        HStack{
            Image(systemName: LocalizedImage.searchIcon)
                .padding(.leading, hasPadding ? 8 : -8)
                .foregroundColor(Color(LocalizedColor.grayIconTextField))
            TextField(placerHolder, text: $inputText)
                .keyboardType(.webSearch)
                .modifier(body1())
                .multilineTextAlignment(.leading)
                .foregroundColor(Color(LocalizedColor.grayTextField))
            if !inputText.isEmpty{
                withAnimation {
                    Button {
                        inputText = ""
                    } label: {
                        ButtonClean(color: colorButtonClean)
                            .padding(.trailing, -8)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(10)
        .background(hasForegroundColor ? Color.gray.opacity(0.3) : Color.clear)
        .cornerRadius(20)
    }
}

struct TextFieldBasicView_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldBasicView(placerHolder: "Buscar", inputText: .constant(""), colorButtonClean: Color(LocalizedColor.primary), hasForegroundColor: true, hasPadding: true)
    }
}
