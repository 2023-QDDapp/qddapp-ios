//
//  CategoriesLoginView.swift
//  qddapp
//
//  Created by gabatx on 22/5/23.
//

import SwiftUI
import WrappingHStack

struct CategoriesListView: View {

    @EnvironmentObject var categoriesViewModel: CategoriesViewModel

    var body: some View {
        ScrollView {
            ZStack {
                WrappingHStack(categoriesViewModel.categories, alignment: .center) { category in
                    Button {
                        categoriesViewModel.setCategories(idCategory: category.id)
                        categoriesViewModel.filterCategoriesSelected()
                        categoriesViewModel.validateNumbersOfCategoriesSelected()
                        if categoriesViewModel.showNumbersOfCategoriesError {
                            categoriesViewModel.validateShowNumbersOfCategoriesError()
                        }
                    } label: {
                        if categoriesViewModel.idCategoriesSelected.contains(category.id){
                                CategoryItem(background: Color(LocalizedColor.secondary), name: category.name)
                                    .padding(.vertical, 4)
                            } else {
                                CategoryItem(background: Color(LocalizedColor.primary), name: category.name)
                                    .padding(.vertical, 4)
                            }
                    }
                }
                .padding(.top, 10)

                if categoriesViewModel.isShowLoading {
                    ProgressView("").scaleEffect(1.2)
                        .padding()
                }
            }
        }
        .onAppear(){
            Task{
                await categoriesViewModel.getAllCategories()
            }
        }
    }
}

struct CategoriesLoginView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesListView()
            .environmentObject(CategoriesViewModel())
    }
}
