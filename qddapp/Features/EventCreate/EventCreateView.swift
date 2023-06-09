//
//  EventCreateView.swift
//  qddapp
//
//  Created by gabatx on 14/5/23.
//

import SwiftUI

struct EventCreateView: View {

    @EnvironmentObject var eventCreateViewModel: EventCreateViewModel
    @EnvironmentObject var mapFilterViewModel: MapFilterViewModel
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var popupViewModel: PopupViewModel
    @StateObject var categoriesViewModel = CategoriesViewModel()
    @State var placeholder: String = "Escribe todo sobre el evento"
    @State var showAlertConfirmCreateEvent: Bool = false
    @State var showAlertIncompleteFields: Bool = false

    let maxCharactersTitle = 30
    let maxCharactersDescription = 200

    init() {
        // Reduce el espacio entre las secciones del formulario.
        UITableView.appearance().sectionFooterHeight = 0
        UITableView.appearance().contentInset.top = -10 // Padding top del form
        // Asigna colores por defecto a los picker(segment)
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color(LocalizedColor.secondary))
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.gray], for: .normal)
    }

    var body: some View {
        ZStack {
            List{
                // -- Título de evento --
                Section(header: Text("Título").modifier(body2())){
                    TextFieldBasicView(placerHolder: "Nombre del evento", inputText: $eventCreateViewModel.tittleEvent.max(maxCharactersTitle), colorButtonClean: Color(LocalizedColor.grayIconTextField), hasForegroundColor: false, hasPadding: false)
                }

                // -- Añadir imagen --
                Section(header: Text("Portada").modifier(body2())){
                    HStack(spacing: 0){
                        Spacer()
                        Button(action: {
                            eventCreateViewModel.showAlertCameraOrGallery = true
                        }) {
                            VStack{
                                Text("Selecciona una imagen")
                                    .modifier(body1())
                                    .foregroundColor(Color(LocalizedColor.secondary))
                                    .multilineTextAlignment(.center)

                                Image(systemName: "plus")
                                    .padding(5)
                                    .foregroundColor(Color(LocalizedColor.primary))
                                    .cornerRadius(5)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color.gray, lineWidth: 1)
                                    )
                            }
                            .frame(maxWidth: .infinity)

                            eventCreateViewModel.imageEvent
                                .resizable()
                                .scaledToFill()
                                .frame(width: 200, height: 100)
                        }
                        .buttonStyle(.plain)
                    }
                    .onChange(of: eventCreateViewModel.imageData) { _ in eventCreateViewModel.loadImage() }
                    .fullScreenCover(isPresented: $eventCreateViewModel.showImagePicker) {
                        ImagePicker(show: $eventCreateViewModel.showImagePicker, image: $eventCreateViewModel.imageData, source: eventCreateViewModel.source)
                            .ignoresSafeArea()
                    }


                    .padding(.horizontal, -18)
                }
                .actionSheet(isPresented: $eventCreateViewModel.showAlertCameraOrGallery) {
                    ActionSheet(
                        title: Text("Añada una imagen"),
                        message: Text("Eliga entre las opciones disponibles"),
                        buttons: [
                            .default(Text("Galería"), action: {
                                eventCreateViewModel.source = .photoLibrary
                                eventCreateViewModel.showImagePicker.toggle()
                            }),
                            .default(Text("Cámara")) {
                                eventCreateViewModel.source = .camera
                                eventCreateViewModel.showImagePicker.toggle()
                            },
                            .destructive(Text("Cancelar"))])
                }

                // -- Fecha --
                Section(header: Text("Fecha").modifier(body2())){
                    VStack{
                        HStack {
                            Text("Desde:")
                            Spacer()
                            DatePicker("Fecha", selection: $eventCreateViewModel.currentDateStart, displayedComponents: [.date, .hourAndMinute])
                                .modifier(body1())
                                .accentColor(Color(LocalizedColor.secondary))
                                .cornerRadius(10)
                                .environment(\.locale, Locale.init(identifier: "es"))
                                .labelsHidden() // Oculta el texto
                                .onChange(of: eventCreateViewModel.currentDateStart) { newValue in
                                    eventCreateViewModel.currentDateEnd = eventCreateViewModel.currentDateStart
                                }
                        }
                        Spacer()
                        HStack{
                            Text("Hasta:")
                            Spacer()
                            DatePicker("", selection: $eventCreateViewModel.currentDateEnd, displayedComponents: [.date, .hourAndMinute])
                                .modifier(body1())
                                .accentColor(Color(LocalizedColor.secondary))
                                .cornerRadius(10)
                                .environment(\.locale, Locale.init(identifier: "es"))
                                .labelsHidden() // Oculta el texto
                                .onChange(of: eventCreateViewModel.currentDateEnd, perform: { selectDate in
                                    // Si la fecha final es menor que la inicial, se iguala
                                    if selectDate < eventCreateViewModel.currentDateStart {
                                        eventCreateViewModel.currentDateEnd = eventCreateViewModel.currentDateStart
                                    }
                                })
                        }
                    }
                }

                // -- Categoría --
                Section(header: Text("Añadir categoría:") .modifier(body2())){
                    CategorySelectView(categoriesViewModel: categoriesViewModel, isPresentedShowCatergoriesView: $eventCreateViewModel.isPresentedShowCatergoriesView)
                }

                // -- Descripción --
                Section(header: Text("Descripción:") .modifier(body2())){
                    TextEditorItem(description: $eventCreateViewModel.descriptionEvent.max(maxCharactersDescription), placeholder: $placeholder)
                }

                // Tipo de evento:
                Section(header: Text("Tipo de evento:").modifier(body2())){
                    // Picker para seleccionar el tipo de evento
                    Picker("", selection: $eventCreateViewModel.typeEvent) {
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
                    MapSwiftUIView(isActiveNavigationToMapFilterView: $eventCreateViewModel.isActiveNavigationtoMapFilterView, distanceCounter: $eventCreateViewModel.distanceCounter, hasDistance: false)
                        .environmentObject(locationManager)
                }
                .padding(.bottom, 12)

                // Boton crear Evento
                Section(header: VStack(alignment: .center, spacing: 0) {
                    Button {
                        popupViewModel.popupBasic(titlePopup: "¿Desea crear el evento con los datos actuales?", titleButton: "Crear evento") {
                            withAnimation {
                                if isCorrectFieldsEventCreationForm() {
                                    let data = prepareEventToBeSent()
                                    print("data: -------> ", data)
                                    Task{
                                        if await eventCreateViewModel.requestToCreateEvent(data: data) {
                                            popupViewModel.popupBasic(titlePopup: "Evento creado correctamente", titleButton: "Aceptar") { }
                                        } else {
                                            popupViewModel.popupBasic(titlePopup: "Error al crear el evento", titleButton: "Aceptar") { }
                                        }
                                    }
                                    resetConfigEvent()
                                } else {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        popupViewModel.popupBasic(titlePopup: "Error. Debe rellenar todos los campos", titleButton: "Aceptar") { }
                                    }
                                }
                            }
                        }
                    } label: {
                        Text("Crear")
                            .buttonStandarDesign()
                    }

                }) {
                    EmptyView()
                }
                .padding(.horizontal, -16)
                if eventCreateViewModel.isLoading {
                    ProgressView("").scaleEffect(1.2)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .onTapGesture {
                self.hideKeyboard()
        }
            if eventCreateViewModel.isLoadingRequestCreateEvent {
                ProgressView().scaleEffect(1.2)
            }
        }
    }

    func isCorrectFieldsEventCreationForm() -> Bool {
        if eventCreateViewModel.tittleEvent.isEmpty {
            return false
        } else if eventCreateViewModel.descriptionEvent.isEmpty {
            return false
        } else if eventCreateViewModel.imageData.count == 0 {
            return false
        } else if eventCreateViewModel.typeEvent.isEmpty {
            return false
        } else if categoriesViewModel.categorySelected == nil {
            return false
        } else if mapFilterViewModel.pickedLocation == nil {
            return false
        }
        return true
    }

    func prepareEventToBeSent() -> EventCreateModel{
        return EventCreateModel(
            id: Int(UserDefaultsManager.shared.userID!)!,
            categorySelected: categoriesViewModel.categorySelected!,
            tittleEvent: eventCreateViewModel.tittleEvent,
            currentDateStart: eventCreateViewModel.currentDateStart.formatDateTime(),
            currentDateEnd: eventCreateViewModel.currentDateEnd.formatDateTime(),
            descriptionEvent: eventCreateViewModel.descriptionEvent,
            imageEvent: eventCreateViewModel.imageData.toBase64(),
            typeEvent: eventCreateViewModel.typeEvent == "Private" ? 0 : 1,
            locationName: mapFilterViewModel.pickedPlaceMark?.locality ?? "Error en la localidad",
            eventLatitude: String(describing: mapFilterViewModel.pickedLocation?.coordinate.latitude ?? 0),
            eventLongitude: String(describing: mapFilterViewModel.pickedLocation?.coordinate.longitude ?? 0))
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

struct EventCreateView_Previews: PreviewProvider {
    static var previews: some View {
        EventCreateView()
            .environmentObject(EventCreateViewModel())
            .environmentObject(MapFilterViewModel())
            .environmentObject(CategoriesViewModel())
            .environmentObject(LocationManager())
            .environmentObject(PopupViewModel())
    }
}

