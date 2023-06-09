//
//  OfflineDataManagerViewModel.swift
//  qddapp
//
//  Created by gabatx on 4/5/23.
//

import Foundation

class OfflineDataManagerViewModel: ObservableObject {

    static var idUser = 3
    private static let kArchiveKey = "OffLineDataOf:\(idUser)"
    var searches: [SearchEventModel] = []
    private let userDefaults: UserDefaults = .standard

    init() {
        self.searches = getAllsearches()
    }

    // Al pulsar el botón de crear se llama a este método
    func saveSearch(search: String){
        let newSearch = SearchEventModel(search: search)
        // Insertamos la busquedas en el array
        searches.insert(newSearch, at: 0) // Lo hacemos así y no con append para que los meta siempre al principio
        // Almacenamos las notas en UserDefaults
        encodeAndSaveAllsearches()
    }

    // Recuperar las busquedas de userDefaults
    func getAllsearches() -> [SearchEventModel] {
        // Si extraer desde userDefaults
        if let searchesData = userDefaults.object(forKey: "\(OfflineDataManagerViewModel.kArchiveKey)") as? Data {
            if let searches = try? JSONDecoder().decode([SearchEventModel].self, from: searchesData) {
                return searches.filter{ $0.idUser == OfflineDataManagerViewModel.idUser }
            }
        }
        return []
    }

    func removeSearch(withId id: String) {
        searches.removeAll(where: {$0.id == id} )
        encodeAndSaveAllsearches()
    }

    func removeAllSearches() {
        searches = []
        encodeAndSaveAllsearches()
    }

    // Codifica las busquedas y las almacena en UserDefauts
    private func encodeAndSaveAllsearches() {
        if let encoded = try? JSONEncoder().encode(searches){
            userDefaults.set(encoded, forKey: "\(OfflineDataManagerViewModel.kArchiveKey)")
        }
    }
}
