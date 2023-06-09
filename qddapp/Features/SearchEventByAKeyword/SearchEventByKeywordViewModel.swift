//
//  SearchEventViewModel.swift
//  qddapp
//
//  Created by gabatx on 1/5/23.
//

import Foundation
import Combine

@MainActor
class SearchEventByKeywordViewModel:NSObject, ObservableObject {
    
    var repository: SearchEventByKeywordRepositoryProtocol = SearchEventByKeywordRepositoryOffline()

    @Published var searches: [SearchEventModel] = []
    @Published var searchText: String = ""
    @Published var isNavigationActiveToSearchEventResultView: Bool = false
    @Published private var isFirstSearch: Bool = true
    private var auxSearches: [SearchEventModel] = []
    var cancellable = Set<AnyCancellable>()

    override init(){
        super.init()

        $searchText
            .debounce(for: .seconds(0.1), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink(receiveValue: { value in
                self.filterSearches(writtenText: value)
            }).store(in: &cancellable)
    }

    // Función que filtra el texto que se va añadiendo al TextField.
    private func filterSearches(writtenText: String) {
        if isFirstSearch {
            auxSearches = searches
            isFirstSearch = false
        }
        searches = writtenText.isEmpty ? auxSearches : auxSearches.filter { $0.search.lowercased().contains(writtenText.lowercased()) }
    }

    func getAllsearches() {
        searches = repository.getAllsearches() ?? []
    }

    func saveSearch(search: String){
        auxSearches = repository.saveSearch(search: search)
    }

    func removeSearch(withId id: String) {
        searches = repository.removeSearch(withId: id)
        auxSearches = searches
    }

    func removeAllSearches() {
        searches = repository.removeallSearches()
        auxSearches = []
    }
}
