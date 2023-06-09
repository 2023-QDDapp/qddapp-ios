//
//  ButtonClean.swift
//  qddapp
//
//  Created by gabatx on 14/5/23.
//

import SwiftUI

struct ButtonClean: View {

    var color: Color

    init(color: Color) {
        self.color = color
    }

    var body: some View {

        Image(systemName: "multiply.circle")
            .renderingMode(.template)
            .resizable()
            .frame(width: 20,height: 20)
            .scaledToFit()
            .padding(.trailing, 8)
            .foregroundColor(color)
    }
}

struct ButtonClean_Previews: PreviewProvider {
    static var previews: some View {
        ButtonClean(color: Color(LocalizedColor.primary))
    }
}
