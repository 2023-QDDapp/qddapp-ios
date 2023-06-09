//
//  CategoriesView.swift
//  qddapp
//
//  Created by gabatx on 8/5/23.
//

import SwiftUI
import WrappingHStack

struct CategoryOneSelectionsView: View {

    @ObservedObject var categoriesViewModel: CategoriesViewModel
    @Binding var isPresentedShowCatergoriesView: Bool

    var iShowTittle = true

    var body: some View {

        ZStack {
            VStack (spacing: 0){
                if iShowTittle {
                    HStack{
                        Spacer()
                        Text("Categorías")
                            .bold()
                            .modifier(h4())
                        Spacer()
                    }
                    .padding()

                    LineSeparator()
                }
                ScrollView {
                    WrappingHStack(categoriesViewModel.categories, alignment: .center) { category in
                        Button {
                            categoriesViewModel.categorySelected = category.id
                            isPresentedShowCatergoriesView = false
                        } label: {
                            if category.id == categoriesViewModel.categorySelected{
                                CategoryItem(background: Color(LocalizedColor.secondary), name: category.name)
                                    .padding(.vertical, 4)
                            } else {
                                CategoryItem(background: Color(LocalizedColor.primary), name: category.name)
                                    .padding(.vertical, 4)
                            }
                        }
                    }
                    .padding(.top, 10)
                }
                .onAppear() {
                    Task{
                        await categoriesViewModel.getAllCategories()
                    }
                }
            }
            .padding(.bottom)

            if categoriesViewModel.isShowLoading {
                ProgressView().scaleEffect(1.2)
            }
        }
    }
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryOneSelectionsView(categoriesViewModel: CategoriesViewModel(), isPresentedShowCatergoriesView: .constant(false))
            .environmentObject(CategoriesViewModel())
    }
}
