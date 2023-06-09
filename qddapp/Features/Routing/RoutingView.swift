//
//  RoutingView.swift
//  qddapp
//
//  Created by gabatx on 19/5/23.
//

import SwiftUI

struct RoutingView: View {

    @EnvironmentObject var routingViewModel: RoutingViewModel
    @EnvironmentObject var popupViewModel: PopupViewModel
    @State private var currentView = RoutingViews.loginHomeView

    var body: some View {

        ZStack {
            VStack {
                // Contenido de tu vista principal aquí
                switch currentView {
                case .loginHomeView:
                    if UserDefaultsManager.shared.isUserLoggedIn {
                        MainScreenView()
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    } else {
                        LoginHomeView()
                            .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)))
                    }
                case .mainScreenView:
                    MainScreenView()
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                case .registerForm:
                    RegisterFormView()
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                }

            }
            .onReceive(routingViewModel.$view) { newView in
                currentView = newView
            }

            // MARK: - Popup básico que mostrará los mensajes necesarios desde cualquier lugar de la app
            if popupViewModel.showPopupBasic {
                PopupBasicView(show: $popupViewModel.showPopupBasic, tittlePopup: popupViewModel.tittlePopup, tittleButton: popupViewModel.titleButton) {
                    popupViewModel.content()
                    withAnimation {
                        popupViewModel.showPopupBasic = false
                    }
                }
            }
        }
    }
}

struct RoutingView_Previews: PreviewProvider {
    static var previews: some View {
        RoutingView()
            .environmentObject(RoutingViewModel())
            .environmentObject(PopupViewModel())
    }
}
