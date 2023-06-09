//
//  CategoriesProfileView.swift
//  qddapp
//
//  Created by gabatx on 28/5/23.
//

import SwiftUI

struct CategoriesProfileView: View {

    @ObservedObject var categoriesViewModel = CategoriesViewModel()

    var body: some View {

        VStack (spacing: 0) {
            VStack(spacing: 20){
                Text("Elige tus preferencias")
                    .modifier(h3(color: (Color(LocalizedColor.secondary))))
                    .multilineTextAlignment(.center)
                Text("Elige las tres categorías que más te interesen")
                    .modifier(body1())
                    .multilineTextAlignment(.center)

                if categoriesViewModel.areSelectedCategories {
                    Text("¡Perfecto! ya tienes tus tres categorías")
                        .bold()
                        .modifier(body1(color: Color(LocalizedColor.primary)))
                        .multilineTextAlignment(.center)
                        .transition(.move(edge: .leading))
                } else {
                    Text("Seleccionadas \(categoriesViewModel.idCategoriesSelected.count)/3")
                        .modifier(body1(color: categoriesViewModel.showNumbersOfCategoriesError ? Color(LocalizedColor.errorValidation) : Color(LocalizedColor.textDark)))
                        .transition(.move(edge: .leading))
                }

                Divider()
                    .lineBottom()
            }
            CategoriesListView()
                .environmentObject(categoriesViewModel)
                .ignoresSafeArea()

        }
        .padding(.top, 30)
        .padding(.horizontal, Constants.paddinGeneral)

    }
}

struct CategoriesProfileView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesProfileView()
            .environmentObject(CategoriesViewModel())
    }
}
