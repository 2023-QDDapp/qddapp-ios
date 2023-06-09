//
//  LineSeparator.swift
//  qddapp
//
//  Created by gabatx on 20/4/23.
//

import SwiftUI

struct LineSeparator: View {
    var body: some View {
        Rectangle()
            .frame(height: Constants.lineWidth)
            .foregroundColor(Color(Constants.colorLineSeparator))
    }
}

struct LineSeparator_Previews: PreviewProvider {
    static var previews: some View {
        LineSeparator()
    }
}

