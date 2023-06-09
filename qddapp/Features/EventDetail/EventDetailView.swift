//
//  EventDetail.swift
//  qddapp
//
//  Created by gabatx on 19/4/23.
//

import SwiftUI
import MapKit

struct EventDetailView: View {
    
    var idEvent: Int
    var idOrganizer: Int

    init(idOrganizer: Int, idEvent: Int) {
        self.idOrganizer = idOrganizer
        self.idEvent = idEvent
    }
    
    @EnvironmentObject var mainScreenViewModel: MainScreenViewModel
    @EnvironmentObject var eventDetailViewModel: EventDetailViewModel
    @EnvironmentObject var eventCreateViewModel: EventCreateViewModel

    
    @State var viewState: Int? = 0
    @State var region = MKCoordinateRegion(
        // El punto central del mapa
        center: CLLocationCoordinate2D(latitude: 40.416775, longitude: -3.703790),
        // Cuanto queremos que se vea del mapa. Se mide en grados
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    
    var body: some View {
        
        ScrollView {
            VStack {
                // ---- IMAGEN -----
                HStack {
                    AsyncImage(url: URL(string: eventDetailViewModel.event.photoEvent)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        // ProgressView()
                        Image(LocalizedImage.backgroundEventDefault)
                            .resizable()
                            .scaledToFill()
                            .redacted(reason: .placeholder)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 250)
                .cornerRadius(Constants.cornerRadius)
                .scaledToFit()
                .clipped(antialiased: true)

                // ---- CABECERA EVENTO -----
                VStack(spacing: 20){
                    Text(eventDetailViewModel.event.tittleEvent)
                        .modifier(h2())
                        .foregroundColor(Color(LocalizedColor.black))
                        .padding(.top)
                    
                    HStack(alignment: .center){
                        VStack(alignment: .leading){
                            HStack {
                                Text("Inicio:")
                                    .bold()
                                Text(eventDetailViewModel.event.dateStart.stringToDate()?.toDate() ?? "No hay fecha")
                            }
                            HStack {
                                Text("Hora:")
                                    .bold()
                                Text(eventDetailViewModel.event.dateStart.stringToDate()?.toTime() ?? "No hay hora")
                            }
                        }
                        .modifier(body1())
                        Spacer()
                        VStack(alignment: .leading){
                            HStack {
                                Text("Fin:")
                                    .bold()
                                Text(eventDetailViewModel.event.dateEnd.stringToDate()?.toDate() ?? "No hay fecha")
                            }
                            HStack {
                                Text("Hora:")
                                    .bold()
                                Text(eventDetailViewModel.event.dateEnd.stringToDate()?.toTime() ?? "No hay hora")
                            }
                        }
                        .modifier(body1())
                    }
                    .padding(.horizontal)
                    .font(.callout)
                    .foregroundColor(Color(LocalizedColor.black))
                    
                    LineSeparator()

                    // ---- ORGANIZADOR Y ASISTENTES -----
                    HStack(alignment: .top, spacing: 5){
                        HStack(alignment: .center){
                            ImageRoundedItem(photo: eventDetailViewModel.event.photoOrganiser, width: 70, height: 70)
                                .overlay(alignment: .topTrailing) {
                                    if eventDetailViewModel.isUserLogin {
                                        Image(systemName: "star.fill")
                                            .styleBasicImageLogo()
                                            .frame(width: 25)
                                            .scaledToFill()
                                            .padding(.leading)
                                            .foregroundColor(Color(LocalizedColor.primary))
                                    }

                                }
                            
                            VStack(alignment: .leading, spacing: 3){
                                Text("Organizador:")
                                    .modifier(body1())
                                    .foregroundColor(Color(LocalizedColor.black))
                                Text((eventDetailViewModel.isUserLogin ? "Eres el organizador" : eventDetailViewModel.event.nameOrganiser)  )
                                    .bold()
                                    .modifier(body1())
                                    .lineLimit(2)
                                    .foregroundColor(Color(LocalizedColor.black))
                                Text("\(eventDetailViewModel.event.age) años")
                                    .modifier(caption())
                                    .foregroundColor(Color(LocalizedColor.black))
                            }
                        }
                        .onTapGesture {
                            self.viewState = 1
                        }
                        .background(
                            NavigationLink(destination: UserDetailView(idUser: eventDetailViewModel.event.idOrganiser), tag: 1, selection: $viewState) { EmptyView() }.opacity(0))
                        Spacer()
                        // ---- ASISTENTES -----
                        VStack(alignment: .leading){
                            Text("Nº asistentes: \(eventDetailViewModel.event.numPartipants)")
                                .modifier(body1())
                            HStack{
                                
                                let participants = eventDetailViewModel.event.participants
                                // Solo mostramos 4 fotos si es que las hay
                                ForEach(0..<min(participants.count, 4), id:\.self) { index in
                                    if index == 0 {
                                        ParticipantPhoto(photoParticipant: participants[index].photo)
                                    } else {
                                        ParticipantPhoto(photoParticipant: participants[index].photo)
                                            .padding(.leading, -40)
                                    }
                                }
                            }
                            .frame(width: 100)
                        }
                        .onTapGesture {
                            self.viewState = 2
                        }
                        .background(
                            NavigationLink(destination: ListOfParticipantsView(participants: eventDetailViewModel.event.participants), tag: 2, selection: $viewState) { EmptyView() }.opacity(0))
                    }
                    
                    LineSeparator()
                    // ---- DESCRIPCIÓN -----
                    Text(eventDetailViewModel.event.description)
                        .modifier(body1())
                    
                    LineSeparator()
                    // ---- MAPA -----
                    VStack(alignment: .leading, spacing: 5){
                        HStack{
                            Text("Ubicacíon:")
                                .modifier(body1())
                            Spacer()
                        }
                        HStack{
                            Text("Linares (Jaén)")
                                .bold()
                                .modifier(body1())
                            Spacer()
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal, Constants.paddingGabatx)
                
                // Añadimos el mapa
                ZStack {
                    Map(
                        coordinateRegion: $region,
                        annotationItems: [
                            Landmark(name: "Qdd", coordinate: CLLocationCoordinate2D(latitude: eventDetailViewModel.event.latitude, longitude: eventDetailViewModel.event.longitude))]) { landmark in
                                MapAnnotation(coordinate: landmark.coordinate) {
                                    Button {
                                        // Abrir la app de mapas
                                        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: landmark.coordinate))
                                        mapItem.name = landmark.name
                                        mapItem.openInMaps(launchOptions: nil)
                                        
                                    } label: {
                                        Image(systemName: "mappin.circle.fill")
                                            .foregroundColor(.red)
                                            .background(.white)
                                            .cornerRadius(50)
                                            .font(.system(size: 30))
                                            .shadow(radius: 1)
                                    }
                                }
                            }
                            .frame(height: 250)
                            .cornerRadius(Constants.cornerRadius)
                            .onAppear(){
                                region = MKCoordinateRegion(
                                    // El punto central del mapa
                                    center: CLLocationCoordinate2D(latitude: 1, longitude: 1),
                                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
                            }
                            .padding(.bottom, 20)
                    if eventDetailViewModel.isLoading {
                        Rectangle()
                            .foregroundColor(Color(uiColor: .systemGray4))
                    }
                }
            }
            .redacted(reason: eventDetailViewModel.isLoading ? .placeholder : [])
            .padding(.horizontal, Constants.paddingEventLayout)
            .navigationBarTitle("Evento", displayMode: .inline)

            NavigationLink(destination: EventCreateView().navigationTitle("Editar evento"), isActive: $eventCreateViewModel.showEventCreateView, label: {})

        }
        .navigationBarItems(trailing: eventDetailViewModel.isUserLogin ? HStack{
            Button {
                eventCreateViewModel.showEventCreateView = true
            } label: {
                Image(systemName: "highlighter")
            }
        } : nil )
        .onAppear(){
            eventDetailViewModel.validateIfIsUserLogin(idUser: idOrganizer)

            Task {
                await eventDetailViewModel.getEventById(id: idEvent)
                updateRegion(
                    latitude: eventDetailViewModel.event.latitude,
                    longitude: eventDetailViewModel.event.longitude)
                await eventDetailViewModel.getEventToUserRelationship(idEvent: idEvent)
            }

            DispatchQueue.main.async {
                withAnimation(.spring()){
                    mainScreenViewModel.animatingshowJoinEventButton = true
                }
                mainScreenViewModel.showJoinEventButton.toggle()
            }
        }
        .onDisappear(){
            DispatchQueue.main.async {
                mainScreenViewModel.animatingshowJoinEventButton = false
                mainScreenViewModel.showJoinEventButton.toggle()
            }
        }
    }
    
    func updateRegion(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        region = MKCoordinateRegion(
            // El punto central del mapa
            center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    }
    
}

struct EventDetail_Preview: PreviewProvider {
    static var previews: some View{
        EventDetailView(idOrganizer: 1, idEvent: 1)
            .environmentObject(MainScreenViewModel())
            .environmentObject(EventDetailViewModel())
            .environmentObject(EventCreateViewModel())
    }
}
