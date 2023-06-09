//
//  TextEditorLineBottomViewModel.swift
//  qddapp
//
//  Created by gabatx on 28/5/23.
//

import Foundation

class TextEditorLineBottomViewModel: ObservableObject {
    @Published  var placeholderAboutMe: String = "Escribe algo sobre ti..."
    @Published  var isShowPlaceHolder = true
    @Published var isShowErrorDescriptionAboutMe = false
    @Published var isWriting = true
}
