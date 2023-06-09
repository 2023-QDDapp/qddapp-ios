//
//  EventsHeldView.swift
//  qddapp
//
//  Created by gabatx on 8/6/23.
//

import SwiftUI
import SlidingTabView

struct EventsHeldView: View {

    @StateObject var eventsHeldViewModel = EventsHeldViewModel()
    @State var selectedTabIndexSliding = 0
    @State private var showItems = false

    var body: some View {
        VStack(alignment: .leading) {

            SlidingTabView(
                selection: self.$selectedTabIndexSliding,
                tabs: ["Mis eventos", "Historial"],
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

                        if eventsHeldViewModel.eventsAttended.count > 0 {

                            ScrollView {
                                // Navega a la vista de detalle del evento seleccionado
                                ForEach(eventsHeldViewModel.eventsAttended, id: \.idEvent){ event in
                                    EventHeldCell(event: event)
                                        .listRowInsets(Constants.listRowInsets)
                                        .listRowBackground(Color.clear)
                                        .redacted(reason: eventsHeldViewModel.isLoading ? .placeholder : [])
                                }
                            }
                            .listStyle(.plain)// Elimina el color de fondo

                        } else {
                            VStack{
                                Spacer()
                                Text("No tienes eventos pendientes")
                                    .modifier(h5())
                                Spacer()
                            }
                        }

                    }
                    .padding(.horizontal, Constants.paddingComponent)
                    .padding(.top, Constants.paddingComponent)
                    .transition(.move(edge: .leading))
                    .onAppear() {
                        Task{
                            await eventsHeldViewModel.getMyEvents()
                        }
                    }

                case 1:
                    VStack(alignment: .leading) {

                        if eventsHeldViewModel.eventsHistory.count > 0 {
                            ScrollView{
                                ForEach(eventsHeldViewModel.eventsHistory, id: \.idEvent){ event in
                                    EventHeldCell(event: event)
                                        .listRowInsets(Constants.listRowInsets)
                                        .listRowBackground(Color.clear)
                                        .redacted(reason: eventsHeldViewModel.isLoading ? .placeholder : [])
                                }
                            }
                            .listStyle(PlainListStyle()) // Elimina el color de fondo
                        } else {
                            VStack{
                                Spacer()
                                Text("No has asistido a ningún evento")
                                    .modifier(h5())
                                Spacer()
                            }
                        }

                    }
                    .padding(.horizontal, Constants.paddingComponent)
                    .padding(.top, Constants.paddingComponent)
                    .transition(.move(edge: .trailing))
                    .onAppear() {
                        Task{
                            await eventsHeldViewModel.getEventsHeldHistory()
                        }
                    }
                default:
                    EmptyView()
                }
                if eventsHeldViewModel.isLoading {
                    EventHeldListSkeleton()
                }
            }
            .padding(.top, -15)
            Spacer()
        }
        .padding(.top, -5)

    }
}

struct EventsHeldView_Previews: PreviewProvider {
    static var previews: some View {
        EventsHeldView()
    }
}
