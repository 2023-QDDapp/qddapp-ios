//
//  SearchEventResultViewModel.swift
//  qddapp
//
//  Created by gabatx on 12/5/23.
//

import Foundation

@MainActor
class SearchEventResultViewModel:ObservableObject {

    var repository: SearchEventResultRepositoryProtocol = SearchEventResultRepositoryApiRest()

    @Published var eventsSearchResult: [EventListModel] = []
    @Published var error: String = ""
    @Published var isLoading = false

    var data: String = ""
    @Published var prepareRequestEventsByFilter = SearchEventFilterModel(
            tittleEvent: nil,
            categorySelected: nil,
            currentDateStart: nil,
            currentDateEnd: nil,
            typeEvent: nil,
            locationName: nil,
            eventLatitude: nil,
            eventLongitude: nil,
            distanceCounter: nil)

    func requestEventsByFilter() -> String {
        var data = ""
        if let tittleEvent = prepareRequestEventsByFilter.tittleEvent {
            data += "titulo=\(tittleEvent)"
        }
        if let categorySelected = prepareRequestEventsByFilter.categorySelected {
            data += "&categoria=\(categorySelected)"
        }
        if let currentDateStart = prepareRequestEventsByFilter.currentDateStart {
            data += "&fecha_hora_inicio=\(currentDateStart)"
        }
        if let currentDateEnd = prepareRequestEventsByFilter.currentDateEnd {
            data += "&fecha_hora_fin=\(currentDateEnd)"
        }
        if let typeEvent = prepareRequestEventsByFilter.typeEvent {
            let type = typeEvent == "Public" ? "público".urlEncode() : "privado"
            data += "&tipo=\(type)"
        }
        if let locationName = prepareRequestEventsByFilter.locationName {
            data += "&location=\(locationName)"
        }
        if let eventLatitude = prepareRequestEventsByFilter.eventLatitude {
            data += "&latitud=\(eventLatitude)"
        }
        if let eventLongitude = prepareRequestEventsByFilter.eventLongitude {
            data += "&longitud=\(eventLongitude)"
        }
        if let distanceCounter = prepareRequestEventsByFilter.distanceCounter {
            data += "&distancia=\(distanceCounter)"
        }
        self.data = data
        return data
    }
    
    func sendDataSearch() async{
        isLoading = true
        let data = requestEventsByFilter()
        eventsSearchResult = await repository.sendDataSearch(data: data)
        isLoading = false

        print("--------- --------- --------- --------- --------- --------- --------- --------- ")
        print("data:", data)
        print("--------- --------- --------- --------- --------- --------- --------- --------- ")
        print("Items: ", eventsSearchResult.count)
        print("--------- --------- --------- --------- --------- --------- --------- --------- ")
        print("prepareRequestEventsByFilter:", prepareRequestEventsByFilter)
        print("--------- --------- --------- --------- --------- --------- --------- --------- ")
        print("eventsSearchResult:", eventsSearchResult)
        print("--------- --------- --------- --------- --------- --------- --------- --------- ")
    }
}

