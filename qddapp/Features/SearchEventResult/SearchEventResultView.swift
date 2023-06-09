//
//  ResultSearchEventView.swift
//  qddapp
//
//  Created by gabatx on 1/5/23.
//

import SwiftUI

struct SearchEventResultView: View {

    var idSearch = ""
    var wordToSearch = ""
    @EnvironmentObject var searchEventByKeywordViewModel : SearchEventByKeywordViewModel
    @EnvironmentObject var searchEventFilterViewModel : SearchEventFilterViewModel
    @EnvironmentObject var searchEventResultViewModel : SearchEventResultViewModel
    @EnvironmentObject var categoriesViewModel : CategoriesViewModel
    @EnvironmentObject var mapFilterViewModel : MapFilterViewModel

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 10) {
                ScrollView {
                    if searchEventResultViewModel.eventsSearchResult.count > 0 {
                        ForEach(searchEventResultViewModel.eventsSearchResult){ event in
                            EventItem(event: event)
                                .listRowInsets(Constants.listRowInsets)
                                .listRowBackground(Color.clear) // Eliminar el color de fondo al pulsar la celda
                        }
                    } else {
                        if !searchEventResultViewModel.isLoading {
                            Text("No se ha encontrado ningún resultado")
                                .modifier(h4())
                                .multilineTextAlignment(.center)
                        }
                    }
                }
                .listStyle(.plain)// Elimina el color de fondo
            }
            .padding(.horizontal, Constants.paddingComponent)
            .padding(.top, Constants.paddingComponent)
            // Animación al pasar de una pestaña a otra
            .navigationTitle("Resultado busqueda")
            .onAppear() {
                searchEventResultViewModel.prepareRequestEventsByFilter = SearchEventFilterModel(
                    tittleEvent: searchEventFilterViewModel.tittleEvent.isEmpty ? nil : searchEventFilterViewModel.tittleEvent.urlEncode(),
                    categorySelected: categoriesViewModel.categorySelected,
                    currentDateStart: searchEventFilterViewModel.currentDateStart.formatDateToISO8601OnlyDate() == Date().formatDateToISO8601OnlyDate() ? nil : searchEventFilterViewModel.currentDateStart.formatDateToISO8601OnlyDate(),
                    currentDateEnd: searchEventFilterViewModel.currentDateStart.formatDateToISO8601OnlyDate() == searchEventFilterViewModel.currentDateEnd.formatDateToISO8601OnlyDate() ? nil : searchEventFilterViewModel.currentDateEnd.formatDateToISO8601OnlyDate(),
                    typeEvent: searchEventFilterViewModel.typeEvent == Constants.typeEventDefault ? nil : searchEventFilterViewModel.typeEvent,
                    locationName: mapFilterViewModel.pickedPlaceMark?.locality,
                    eventLatitude: mapFilterViewModel.pickedLocation?.coordinate.latitude,
                    eventLongitude: mapFilterViewModel.pickedLocation?.coordinate.longitude,
                    distanceCounter: searchEventFilterViewModel.distanceCounter == 200 ? nil : searchEventFilterViewModel.distanceCounter)
                Task {
                    await searchEventResultViewModel.sendDataSearch()
                }
            }
            if searchEventResultViewModel.isLoading {
                ProgressView("").scaleEffect(1.3)
            }
        }
    }
}

struct ResultSearchEventView_Previews: PreviewProvider {
    static var previews: some View {
        SearchEventResultView(idSearch: "")
            .environmentObject(SearchEventByKeywordViewModel())
            .environmentObject(SearchEventResultViewModel())
            .environmentObject(SearchEventFilterViewModel())
            .environmentObject(CategoriesViewModel())
            .environmentObject(MapFilterViewModel())
    }
}
