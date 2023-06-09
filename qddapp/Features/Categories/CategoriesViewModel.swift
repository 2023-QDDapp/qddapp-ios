//
//  CategoriesViewModel.swift
//  qddapp
//
//  Created by gabatx on 8/5/23.
//

import Foundation
import SwiftUI

@MainActor
class CategoriesViewModel: ObservableObject {

    var repository: CategoriesRepositoryProtocol = CategoriesRepositoryApiRest()

    // Categorías (selección de una sola categoría)
    @Published var categories: [CategoryModel] = []
    @Published var categorySelected:Int?

    // Categorías (perfil)
    @Published var idCategoriesSelected:[Int] = []
    @Published var categoriesSelected:[CategoryModel] = []
    @Published var areSelectedCategories = false
    @Published var showNumbersOfCategoriesError = false
    @Published var showSelectAllCategoriesView = false
    @Published var isShowLoading = false

    // MARK: - API
    func getAllCategories() async {
        isShowLoading = true
        categories = await repository.getAllCategories()
        isShowLoading = false
    }

    // MARK: - Categorías - Intereses
    func setCategories(idCategory: Int) {
        if !idCategoriesSelected.contains(idCategory){
            if idCategoriesSelected.count < 3 {
                idCategoriesSelected.append(idCategory)
            }
        } else {
            idCategoriesSelected.removeAll(where: { $0 == idCategory})
            showNumbersOfCategoriesError = false
        }
    }

    func validateNumbersOfCategoriesSelected() {
        if idCategoriesSelected.count == 3 {
            withTransaction(Transaction(animation: .easeIn(duration: 0.2))) {
                areSelectedCategories = true
            }
        } else {
            withTransaction(Transaction(animation: .easeOut(duration: 0.2))) {
                areSelectedCategories = false
            }
        }
    }

    func validateShowNumbersOfCategoriesError() {
        if idCategoriesSelected.count == 3 {
            showNumbersOfCategoriesError = false
        } else {
            showNumbersOfCategoriesError = true
        }
    }



    func filterCategoriesSelected() {
        categoriesSelected = categories.filter { idCategoriesSelected.contains($0.id)}
    }
}
