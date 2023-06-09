//
//  SearchEventRepository.swift
//  qddapp
//
//  Created by gabatx on 1/5/23.
//

import Foundation

protocol SearchEventByKeywordRepositoryProtocol {
    func saveSearch(search: String) -> [SearchEventModel]
    func getAllsearches() -> [SearchEventModel]?
    func removeSearch(withId id: String) -> [SearchEventModel]
    func removeallSearches() -> [SearchEventModel]
}

// ---- USERDEFAULT ---//
class SearchEventByKeywordRepositoryOffline: SearchEventByKeywordRepositoryProtocol {
    var requestManager = OfflineDataManagerViewModel()
    func saveSearch(search: String) -> [SearchEventModel] {
        requestManager.saveSearch(search: search)
        return requestManager.searches
    }
    func getAllsearches() -> [SearchEventModel]? {  requestManager.searches }
    func removeSearch(withId id: String) -> [SearchEventModel] {
        requestManager.removeSearch(withId: id)
        return requestManager.searches
    }
    func removeallSearches() -> [SearchEventModel] {
        requestManager.removeAllSearches()
        return requestManager.searches
    }
}

// ---- MOCK ---//
class SearchEventByKeywordRepositoryMock: SearchEventByKeywordRepositoryProtocol {
    
    var requestManager = JsonManager()
    func saveSearch(search: String) -> [SearchEventModel] { [] }
    func getAllsearches() -> [SearchEventModel]? {
        let json = "Busquedas"
        let searches: [SearchEventModel] = requestManager.get(json: json) ?? []
        return searches.filter{$0.idUser == OfflineDataManagerViewModel.idUser}
    }
    func removeSearch(withId id: String) -> [SearchEventModel] { [] }
    func removeallSearches() -> [SearchEventModel] { [] }
}
