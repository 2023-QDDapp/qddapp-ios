//
//  CategoryItem.swift
//  qddapp
//
//  Created by gabatx on 8/5/23.
//

import SwiftUI

struct CategoryItem: View {

    @State var color: Color = .white
    var background: Color = Color(LocalizedColor.primary)
    var name: String

    init(background: Color, name: String) {
        self.background = background
        self.name = name
    }

    var body: some View {
        Text(name)
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(background)
            .cornerRadius(100)
            .foregroundColor(.white)
            .modifier(body1(color: color))
    }
}

struct CategoryItem_Previews: PreviewProvider {
    static var previews: some View {
        CategoryItem(background: Color(LocalizedColor.primary), name: "Una categoría")
    }
}
