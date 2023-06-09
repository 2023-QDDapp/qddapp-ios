//
//  RoutingViewModel.swift
//  qddapp
//
//  Created by gabatx on 19/5/23.
//

import Foundation

enum RoutingViews{
    case loginHomeView
    case mainScreenView
    case registerForm
}

class RoutingViewModel: ObservableObject {
    @Published var view: RoutingViews = .loginHomeView
}
