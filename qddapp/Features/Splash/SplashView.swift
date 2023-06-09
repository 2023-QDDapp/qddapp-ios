//
//  SplashView.swift
//  qddapp
//
//  Created by gabatx on 15/4/23.
//

import SwiftUI
import SlidingTabView

struct SplashView: View {

    @State private var showDetail = false

    var body: some View {
        ZStack {
            Image(LocalizedImage.backgroundQdd)
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            Image(LocalizedImage.logo)
                .resizable()
                .frame(width: 185, height: 105)
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}

