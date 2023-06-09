//
//  PopupViewModel.swift
//  qddapp
//
//  Created by gabatx on 31/5/23.
//

import Foundation
import SwiftUI

class PopupViewModel: ObservableObject {
    @Published var showPopupBasic = false
    @Published var tittlePopup = ""
    @Published var titleButton = ""
    @Published var content: () -> Void = {}

    // MARK: - Basic popup
    func popupBasic(titlePopup: String, titleButton: String, content: @escaping () -> Void) {
        self.tittlePopup = titlePopup
        self.titleButton = titleButton
        self.content = content
        withAnimation {
            showPopupBasic = true
        }
    }
}
