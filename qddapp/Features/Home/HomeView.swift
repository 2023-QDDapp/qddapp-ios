//
//  HomeView.swift
//  qddapp
//
//  Created by gabatx on 15/4/23.
//

import SlidingTabView
import SwiftUI

struct HomeView: View {
    
    @State var selectedTabIndexSliding = 0
    @State private var showItems = false

    @EnvironmentObject var homeViewModel: HomeViewModel
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            SlidingTabView(
                selection: self.$selectedTabIndexSliding,
                tabs: ["Para ti", "Siguiendo"],
                font: Font.custom("Montserrat-SemiBold", size: 16).bold(),
                animation: Animation.easeOut,
                activeAccentColor: Color(LocalizedColor.secondary),
                inactiveAccentColor: Color(LocalizedColor.primary),
                selectionBarColor: Color(LocalizedColor.secondary),
                selectionBarHeight: 3
            )
            
            ZStack {
                Image(LocalizedImage.backgroundQdd)
                    .renderingMode(.template)
                    .resizable(resizingMode: .tile)
                    .foregroundColor(Color(LocalizedColor.primary))
                
                switch selectedTabIndexSliding {
                case 0:
                    VStack(alignment: .leading, spacing: 10) {
                        ScrollView {
                            ForEach(homeViewModel.eventsForYou){ event in
                                EventItem(event: event)
                                    .listRowInsets(Constants.listRowInsets)
                                    .listRowBackground(Color.clear) // Eliminar el color de fondo al pulsar la celda
                            }
                        }
                        .listStyle(.plain)// Elimina el color de fondo
                    }
                    .padding(.horizontal, Constants.paddingComponent)
                    .padding(.top, Constants.paddingComponent)
                    // Animación al pasar de una pestaña a otra
                    .transition(.move(edge: .leading))
                    //.animation(.easeOut(duration: 0.3))
                    .onAppear() {
                        Task{
                            await homeViewModel.getEventsForYou()
                        }
                    }
                    
                case 1:
                    VStack(alignment: .leading) {
                        if homeViewModel.eventsFollowedUsers.count > 0 {
                            ScrollView{
                                ForEach(homeViewModel.eventsFollowedUsers){ event in
                                    EventItem(event: event)
                                        .listRowInsets(Constants.listRowInsets)
                                        .listRowBackground(Color.clear)
                                }
                            }
                            .listStyle(PlainListStyle()) // Elimina el color de fondo
                        } else {
                            VStack{
                                Spacer()
                                Text("Aún no sigues a nadie.")
                                    .modifier(h5())
                                Spacer()
                            }
                        }


                    }
                    .padding(.horizontal, Constants.paddingComponent)
                    .padding(.top, Constants.paddingComponent)
                    // Animación al pasar de una pestaña a otra
                    .transition(.move(edge: .trailing))
                    //.animation(.easeOut(duration: 0.3))
                    .onAppear() {
                        Task{
                            await homeViewModel.getEventsFollowedUsers()
                        }
                    }
                default:
                    EmptyView()
                }
                // Muestra el esqueleto de carga mientras carga
                if homeViewModel.isLoading {
                    EventListSkeleton()
                }
            }
            .padding(.top, -15)
            Spacer()
        }
        .padding(.top, -5)
        .refreshable {
            showItems = true
        }

    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(HomeViewModel())
    }
}
