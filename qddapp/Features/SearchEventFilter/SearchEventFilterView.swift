//
//  SearchEventFilterView.swift
//  qddapp
//
//  Created by gabatx on 5/5/23.
//

import MapKit
import SwiftUI

struct SearchEventFilterView: View {

    @EnvironmentObject var searchEventFilterViewModel: SearchEventFilterViewModel
    @EnvironmentObject var searchEventByKeywordViewModel: SearchEventByKeywordViewModel
    @EnvironmentObject var mapFilterViewModel: MapFilterViewModel
    @EnvironmentObject var locationManager: LocationManager
    @StateObject var categoriesViewModel =  CategoriesViewModel()
    @State private var animate = false

    init() {
        // Reduce el espacio entre las secciones del formulario.
        UITableView.appearance().sectionFooterHeight = 0
        UITableView.appearance().contentInset.top = -30 // Padding top del form
        // Asigna colores por defecto a los picker(segment)
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color(LocalizedColor.secondary))
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.gray], for: .normal)
    }

    var body: some View {

        VStack{
            HStack {
                ZStack {
                    Text("Filtro")
                        .bold()
                        .modifier(body1())
                    HStack{
                        Spacer()
                        Button {
                            searchEventFilterViewModel.isPresentedSearchEventFilterView = false
                        } label: {
                            Image("cerrar")
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20)
                                .foregroundColor(Color(LocalizedColor.secondary))
                        }
                    }
                    HStack{
                        Button {
                            resetConfigFilter()
                        } label: {
                            Text("Restablecer")
                                .foregroundColor(Color(LocalizedColor.secondary))
                        }
                        Spacer()
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)

            List {
                Section(header: Text("Título") .modifier(body2())){
                    HStack{
                        Image(systemName: LocalizedImage.searchIcon)
                        TextField("Nombre de evento", text: $searchEventFilterViewModel.tittleEvent)
                            .keyboardType(.webSearch)
                            .modifier(body1())
                            .multilineTextAlignment(.leading)
                            .padding(8)
                    }
                }

                Section(header: Text("Añadir categoría:") .modifier(body2())){
                    CategorySelectView(categoriesViewModel: categoriesViewModel, isPresentedShowCatergoriesView: $searchEventFilterViewModel.isPresentedShowCatergoriesView)
                }

                Section(header: Text("Fecha").modifier(body2())){
                    HStack(alignment: .center){
                        Spacer()
                        DatePicker("Fecha", selection: $searchEventFilterViewModel.currentDateStart, displayedComponents: [.date])
                            .modifier(body1())
                            .accentColor(Color(LocalizedColor.secondary))
                            .cornerRadius(10)
                            .environment(\.locale, Locale.init(identifier: "es"))
                            .labelsHidden() // Oculta el texto
                            .onChange(of: searchEventFilterViewModel.currentDateStart) { newValue in
                                searchEventFilterViewModel.currentDateEnd = searchEventFilterViewModel.currentDateStart
                                            }
                        Image(systemName: "arrow.right")
                        DatePicker("", selection: $searchEventFilterViewModel.currentDateEnd, displayedComponents: [.date])
                            .modifier(body1())
                            .labelsHidden()
                            .accentColor(Color(LocalizedColor.secondary))
                            .cornerRadius(10)
                            .environment(\.locale, Locale.init(identifier: "es"))
                            .onChange(of: searchEventFilterViewModel.currentDateEnd, perform: { selectDate in
                                // Si la fecha final es menor que la inicial, se iguala
                                if selectDate < searchEventFilterViewModel.currentDateStart {
                                    searchEventFilterViewModel.currentDateEnd = searchEventFilterViewModel.currentDateStart
                                }
                            })
                        Spacer()
                    }
                }

                Section(header: Text("Tipo de evento:").modifier(body2())){
                    // Picker para seleccionar el tipo de evento
                    Picker("", selection: $searchEventFilterViewModel.typeEvent) {
                        Text(Constants.typeEventDefault).tag(Constants.typeEventDefault)
                            .modifier(body1())
                        Text("Público").tag("Public")
                            .modifier(body1())
                        Text("Privado").tag("Private")
                            .modifier(body1())
                    }
                    .pickerStyle(.segmented)
                    .labelsHidden()
                    // Color al seleccionar
                    .accentColor(Color(LocalizedColor.secondary))
                }

                // Mapa
                Section(header: Text("Localización:").modifier(body2())) {
                    MapSwiftUIView(isActiveNavigationToMapFilterView: $searchEventFilterViewModel.isActiveNavigationtoMapFilterView, distanceCounter: $searchEventFilterViewModel.distanceCounter, hasDistance: true)
                    .environmentObject(locationManager)
                }

                Section(header: VStack(alignment: .center, spacing: 0) {
                    Button {
                        searchEventFilterViewModel.isPresentedSearchEventFilterView = false
                        searchEventByKeywordViewModel.isNavigationActiveToSearchEventResultView = true
                    } label: {
                        Text("Buscar")
                            .buttonStandarDesign()
                    }
                }) {
                    EmptyView()
                }
                .padding(.horizontal, -16)
            }
            .padding(.top, 20)
            .onTapGesture {
                self.hideKeyboard()
            }
        }
        .foregroundColor(Color(LocalizedColor.textDark))
        .modifier(FormHiddenBackground())
        .background(Color(uiColor: .systemGray6))
        .onAppear(){
            resetConfigFilter()
        }
    }

    func resetConfigFilter(){
        searchEventFilterViewModel.tittleEvent = ""
        categoriesViewModel.categorySelected = nil
        searchEventFilterViewModel.currentDateStart = Date()
        searchEventFilterViewModel.currentDateEnd = Date()
        searchEventFilterViewModel.typeEvent = Constants.typeEventDefault
        searchEventFilterViewModel.distanceCounter = 200
        mapFilterViewModel.pickedPlaceMark = nil
        mapFilterViewModel.pickedLocation = nil
    }
}

struct SearchEventFilterView_Previews: PreviewProvider {
    static var previews: some View {
        SearchEventFilterView()
            .environmentObject(SearchEventFilterViewModel())
            .environmentObject(LocationManager())
            .environmentObject(SearchEventByKeywordViewModel())
            .environmentObject(MapFilterViewModel())
    }
}

struct FormHiddenBackground: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content.scrollContentBackground(.hidden)
        } else {
            content.onAppear {
                UITableView.appearance().backgroundColor = .clear
            }
            .onDisappear {
                UITableView.appearance().backgroundColor = .systemGroupedBackground
            }
        }
    }
}
