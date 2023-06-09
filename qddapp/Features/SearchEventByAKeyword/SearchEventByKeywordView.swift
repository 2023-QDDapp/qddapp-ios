//
//  SearchEventView.swift
//  qddapp
//
//  Created by gabatx on 1/5/23.
//

import SwiftUI

struct SearchEventByKeyword: View {

    @State var color: Color = .black
    @State var showAlertBasic = false
    @EnvironmentObject var searchEventForAKeywordViewModel: SearchEventByKeywordViewModel

    var body: some View {
        VStack(alignment: .center){
            HStack{
                Text("Busquedas recientes")
                    .modifier(h4(color: color))
                Spacer()
                if !searchEventForAKeywordViewModel.searches.isEmpty {
                    Button {
                        showAlertBasic = true
                    } label: {
                        Image(systemName: "multiply.circle.fill")
                            .foregroundColor(.gray)
                    }
                    .alert(isPresented: $showAlertBasic) {
                        Alert(
                            title: Text("Borrar historial"),
                            message: Text("Desea borrar las busquedas recientes"),
                            primaryButton: .default(Text("Aceptar"), action: {
                                searchEventForAKeywordViewModel.removeAllSearches()
                            }),
                            secondaryButton: .destructive(Text("Cancelar")))
                    }
                }
            }
            .padding(.horizontal)
            Spacer()
            if searchEventForAKeywordViewModel.searches.isEmpty {
                Text("No tienes búsquedas realizadas")
                    .navigationBarTitleDisplayMode(.inline)
                Spacer()
            } else {
                ScrollView {
                    ForEach(Array(searchEventForAKeywordViewModel.searches.enumerated()), id: \.1.id) { index, search in
                        CellSearchInput(search: .constant(search), id: index )
                            .padding(.vertical, 4)
                            .swipeActions(edge: .trailing) {
                                Button {
                                    withAnimation {
                                        searchEventForAKeywordViewModel.removeSearch(withId: search.id)
                                    }
                                } label: {
                                    Label("Eliminar", systemImage: "trash")
                                }
                                .tint(.red)
                            }
                            .navigationTitle("Volver")
                            .navigationBarTitleDisplayMode(.inline)
                    }
                }
                .listStyle(InsetGroupedListStyle())
                Spacer()
            }
        }
        .background(NavigationLink(destination:SearchEventResultView(), isActive: $searchEventForAKeywordViewModel.isNavigationActiveToSearchEventResultView) {
            EmptyView().opacity(0)
        })
        .onAppear(){
            searchEventForAKeywordViewModel.getAllsearches()
        }
        .onTapGesture {
            self.hideKeyboard()
        }
    }
}

struct SearchEventView_Previews: PreviewProvider {
    static var previews: some View {
        SearchEventByKeyword()
            .environmentObject(SearchEventByKeywordViewModel())
    }
}

struct CellSearchInput: View {

    @EnvironmentObject var searchEventFilterViewModel: SearchEventFilterViewModel
    @Binding var search: SearchEventModel?
    @State var viewState: Int? = nil
    var id: Int

    init(search: Binding<SearchEventModel?>, id: Int) {
        self._search = search
        self.id = id
    }

    var body: some View {
        if let search = search  {
            HStack(spacing: 10){
                Text(search.search)
                HStack{
                    EmptyView()
                }
                Spacer()
                Image(systemName: "arrow.up.left")
                    .foregroundColor(Color(LocalizedColor.primary))
            }
            .onTapGesture {
                self.viewState = id
                searchEventFilterViewModel.tittleEvent = search.search
            }
            .background(
                NavigationLink(destination: SearchEventResultView(), tag: id, selection: $viewState) { EmptyView() }.opacity(0)
            )
            .listRowInsets(Constants.listRowInsets)
            .listRowBackground(Color.clear) // Eliminar el color de fondo al pulsar la celda
            .padding(.horizontal)
        }
        else {
            EmptyView()
        }
    }
}
