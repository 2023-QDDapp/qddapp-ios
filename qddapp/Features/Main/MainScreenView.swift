//
//  MainScreenView.swift
//  qddapp
//
//  Created by gabatx on 15/4/23.
//

import SwiftUI

struct MainScreenView: View {
    
    @State private var contTapHome = 0
    @State private var isNavigationActive = false
    @State private var isPresentedSearchRecentView = false
    @EnvironmentObject var mainScreenViewModel: MainScreenViewModel
    @EnvironmentObject var searchEventForAKeywordViewModel: SearchEventByKeywordViewModel
    @EnvironmentObject var searchEventFilterViewModel: SearchEventFilterViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @EnvironmentObject var homeViewModel: HomeViewModel
    @EnvironmentObject var eventDetailViewModel: EventDetailViewModel
    @EnvironmentObject var eventCreateViewModel: EventCreateViewModel
    @EnvironmentObject var categoriesViewModel: CategoriesViewModel
    @EnvironmentObject var mapFilterViewModel: MapFilterViewModel
    @EnvironmentObject var popupViewModel: PopupViewModel

    // Al hacer doble pulsación sobre el home borra la navegacion y vuelve al principio
    @State var selectedTab: Tab = .HomeView
    @State private var firstPass = false
    @State private var showAlertResetConfigEvent = false

    // Permite que cuando le demos al icono del home dos veces nos lleve al principio
    private var selection: Binding<Tab> { Binding(  // << this !!
        get: { selectedTab },
        set: {
            selectedTab = $0

            if $0 == .HomeView  {
                // Acción a realizar al pulsar dos veces sobre el home
                if firstPass == true {
                    NavigationUtil.popToRootView() // Resetear el NavigationView
                    firstPass = false  // << reset !!
                    return
                }
                firstPass = true
            }
            if $0 != .HomeView {
                firstPass = false
            }
        }
    )}

    init() {
        UITabBar.appearance().backgroundColor = UIColor.white
    }
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            TabView(selection: selection) {

                // -- Inicio --
                NavigationView {
                    HomeView()
                        .toolbar {
                            ToolbarItem(placement: .principal){
                                Image(LocalizedImage.logo)
                                    .resizable()
                                    .frame(width: 58, height: 32)
                            }
                        }
                        .navigationBarTitleDisplayMode(.inline)
                }
                .tabItem {
                    // Imagen house de color verde
                    Image(systemName: LocalizedImage.homeIcon)
                    Text("Inicio")
                }
                .tag(Tab.HomeView)
                //.navigationViewStyle(.stack)

                // -- Buscar --
                NavigationView {
                    ZStack {
                        if isPresentedSearchRecentView {
                            // Muestra con una animación la pantalla de búsquedas recientes
                            SearchEventByKeyword()
                                .onAppear(){
                                    searchEventForAKeywordViewModel.searchText = ""
                                }
                        }
                    }
                    .padding(.top, 20)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            HStack{
                                TextFieldBasicView(placerHolder: "Busca tu Qdd", inputText: $searchEventForAKeywordViewModel.searchText, colorButtonClean: Color(LocalizedColor.grayIconTextField))
                                    .padding(.top, 10)
                                    .padding(.leading, 10)
                                // Al pulsar en el campo
                                    .onTapGesture {
                                        isPresentedSearchRecentView = true
                                    }
                                // Al pulsar en el botón de ir del teclado navega a la pantalla de resultados
                                    .onSubmit {
                                        if !searchEventForAKeywordViewModel.searchText.isEmpty{
                                            // Debe estar en este orden
                                            searchEventForAKeywordViewModel.saveSearch(search: searchEventForAKeywordViewModel.searchText)
                                            searchEventForAKeywordViewModel.isNavigationActiveToSearchEventResultView = true
                                            // Le damos el valor a la busqueda principal
                                            searchEventFilterViewModel.tittleEvent = searchEventForAKeywordViewModel.searchText
                                        }
                                    }
                                    //.navigationViewStyle(.stack)
                            }
                            .padding(.bottom, 10)
                        }
                        
                        ToolbarItem(placement: .primaryAction){
                            Button {
                                searchEventFilterViewModel.isPresentedSearchEventFilterView = true
                            } label: {
                                Image(systemName: LocalizedImage.filterIcon2)
                                    .frame(width: 40, height: 40)
                                    .fullScreenCover(
                                        // Aquí le decimos que cuando el booleano isPresented sea true, se muestre la vista.
                                        isPresented: $searchEventFilterViewModel.isPresentedSearchEventFilterView,
                                        // Cuando se cierre la vista, se ejecuta la acción que le hemos indicado.
                                        onDismiss: { },
                                        // Aquí le decimos que contenido queremos que muestre la vista.
                                        content: {
                                            SearchEventFilterView()
                                        })
                            }
                        }
                    }
                }
                .tabItem {
                    Image(systemName: LocalizedImage.searchIcon)
                    Text("Buscar")
                }
                .tag(Tab.SearchView)
                .navigationBarTitleDisplayMode(.inline)
                .onAppear(){
                    // isPresentedSearchRecentView = false
                    isPresentedSearchRecentView = true
                }
                
                // -- Crear evento--
                NavigationView {

                    EventCreateView()
                        .toolbar {
                            ToolbarItem(placement: .principal) {
                                Text("Crear evento")
                                    .font(.headline)
                                    .bold()
                            }

                            ToolbarItem(placement: .primaryAction){
                                Button {
                                    popupViewModel.popupBasic(titlePopup: "Si acepta se reiniciarán los campos", titleButton: "Reiniciar") {
                                        withAnimation {
                                            resetConfigEvent()
                                        }
                                    }
                                } label: {
                                    Image(systemName: "arrow.clockwise")
                                        .frame(width: 40, height: 40)
                                        .fullScreenCover(
                                            // Aquí le decimos que cuando el booleano isPresented sea true, se muestre la vista.
                                            isPresented: $searchEventFilterViewModel.isPresentedSearchEventFilterView,
                                            // Cuando se cierre la vista, se ejecuta la acción que le hemos indicado.
                                            onDismiss: { },
                                            // Aquí le decimos que contenido queremos que muestre la vista.
                                            content: {
                                                SearchEventFilterView()
                                            })
                                }
                            }
                        }
                        .navigationBarTitleDisplayMode(.inline)
                }
                .tabItem {
                    Image(systemName: LocalizedImage.addEventIcon)
                        .resizable()
                        .frame(width: 23, height: 23)
                    Text("Crear")
                }
                .tag(Tab.CreateEventView)
                
                // -- Notificaciones --
                NavigationView {
                    NotificationsView()
                }
                .tabItem {
                    Image(systemName: LocalizedImage.notificationIcon)
                    Text("Notificaciones")
                }
                .badge(3)
                .tag(Tab.NotificationView)
                
                // -- Perfil --
                NavigationView {
                    UserDetailView(idUser: Int(UserDefaultsManager.shared.userID!)!)
                        .toolbar {
                            ToolbarItem(placement: .principal) {
                                Text("Perfil")
                                    .font(.headline)
                                    .bold()
                            }
                        }
                }
                .tabItem {
                    Image(systemName: LocalizedImage.profileIcon)
                    Text("Perfil")
                }
                .tag(Tab.ProfileView)
            }
            .edgesIgnoringSafeArea(.top)
            .accentColor(Color(LocalizedColor.secondary))
            // Mostramos el botón
            ButtonJoinEvent()
                .offset(y: mainScreenViewModel.animatingshowJoinEventButton ? 0 : 100)


        }
        .ignoresSafeArea(.all)
        //.navigationViewStyle(StackNavigationViewStyle()) // Sirve para regular las constraint
    }

    func resetConfigEvent(){
        eventCreateViewModel.tittleEvent = ""
        eventCreateViewModel.descriptionEvent = ""
        categoriesViewModel.categorySelected = nil
        eventCreateViewModel.currentDateStart = Date()
        eventCreateViewModel.currentDateEnd = Date()
        eventCreateViewModel.typeEvent = Constants.typeEventPublic
        eventCreateViewModel.imageEvent = Image(Constants.imageEventTemplate)
        mapFilterViewModel.pickedPlaceMark = nil
        mapFilterViewModel.pickedLocation = nil
    }
}

enum Tab: Hashable {
    case HomeView
    case SearchView
    case CreateEventView
    case NotificationView
    case ProfileView
}

struct MainScreenView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreenView()
            .environmentObject(MainScreenViewModel())
            .environmentObject(HomeViewModel())
            .environmentObject(SearchEventByKeywordViewModel())
            .environmentObject(OfflineDataManagerViewModel())
            .environmentObject(SearchEventFilterViewModel())
            .environmentObject(EventDetailViewModel())
            .environmentObject(SettingsViewModel())
            .environmentObject(PopupViewModel())
    }
}

