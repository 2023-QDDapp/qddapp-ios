//
//  CategorySelectView.swift
//  qddapp
//
//  Created by gabatx on 14/5/23.
//

import SwiftUI

struct CategorySelectView: View {

    @ObservedObject var categoriesViewModel: CategoriesViewModel
    @Binding var isPresentedShowCatergoriesView: Bool

    var body: some View {

        HStack{
            if let category = categoriesViewModel.categories.first(where: { $0.id == categoriesViewModel.categorySelected }) {
                HStack {
                    CategoryItem(background: Color(LocalizedColor.secondary), name: category.name)
                        .padding(.vertical, 4)
                    Button {
                        withAnimation {
                            categoriesViewModel.categorySelected = nil
                        }
                    } label: {
                        Image(systemName: "multiply.circle")
                    }
                    .buttonStyle(.plain)
                }
            } else {
                Text("No hay categoria seleccionada")
                    .modifier(body1())
            }
            Spacer()
            Button {
                isPresentedShowCatergoriesView = true
            } label: {
                Image(systemName: "plus")
                    .padding(5)
                    .foregroundColor(Color(LocalizedColor.primary))
                    .cornerRadius(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 1)
                    )
            }
            .buttonStyle(.plain) // Elimina el color de la pulsación
            .sheet(isPresented: $isPresentedShowCatergoriesView) {
                CategoryOneSelectionsView(categoriesViewModel: categoriesViewModel, isPresentedShowCatergoriesView: $isPresentedShowCatergoriesView)
                    .padding(Constants.paddinGeneral)
            }
        }
        .frame(height: 40)
    }
}

struct CategorySelectView_Previews: PreviewProvider {
    static var previews: some View {
        CategorySelectView(categoriesViewModel: CategoriesViewModel(),
                           isPresentedShowCatergoriesView: .constant(true))
            .environmentObject(CategoriesViewModel())
    }
}
