//
//  ViewExtension.swift
//  qddapp
//
//  Created by gabatx on 8/5/23.
//

import Foundation
import SwiftUI


extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
