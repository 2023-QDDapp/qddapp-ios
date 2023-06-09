//
//  CategoriesRepository.swift
//  qddapp
//
//  Created by gabatx on 8/5/23.
//

import Foundation

protocol CategoriesRepositoryProtocol {
    func getAllCategories() async -> [CategoryModel]
}

// - MARK: Api
class CategoriesRepositoryApiRest {
    let requestManager: NetworkManager = NetworkManager(urlBase: Constants.urlBase)
}

extension CategoriesRepositoryApiRest: CategoriesRepositoryProtocol{

    func getAllCategories() async -> [CategoryModel] {
        let endPoint = "categorias"
        do {
            return try await requestManager.get(endPoint: endPoint)
        } catch {
            print("Error en la obtención de datos: \(error)")
            return []
        }

    }
}

// - MARK: Mock
class CategoriesRepositoryMock: CategoriesRepositoryProtocol {
    var requestManager = JsonManager()

    func getAllCategories() async -> [CategoryModel] {
        let json = "Categorias"
        let categories: [CategoryModel] = requestManager.get(json: json) ?? []
        return categories
    }
}
