//
//  ContentView.swift
//  qddapp
//
//  Created by gabatx on 17/4/23.
//

import SwiftUI

struct ContentView: View {

    @State var isActive = false

    var body: some View {
        if isActive {
            RoutingView()
        } else {
            SplashView()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withTransaction(Transaction.init(animation: .easeIn)) {
                            self.isActive = true
                        }
                    }
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
