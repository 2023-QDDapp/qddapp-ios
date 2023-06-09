//
//  EventItem.swift
//  qddapp
//
//  Created by gabatx on 16/4/23.
//

import SwiftUI

struct EventItem: View {

    var event: EventListModel
    @State var viewState: Int? = 0

    init(event: EventListModel) {
        self.event = event
    }

    var body: some View {

        VStack {
            VStack(spacing: Constants.paddingEventItemInternal){
                VStack(spacing: 0) {
                    HStack{
                        Spacer()
                        Text("#\(event.category)")
                            .padding(.horizontal, 8)
                            .padding(.top, 5)
                            .padding(.bottom, -2)
                            .modifier(body2())
                    }
                    .padding(.bottom, 0)

                    HStack(alignment: .top){
                        HStack{
                            ImageRoundedItem(photo: event.photoOrganiser, width: 60, height: 60)

                            VStack(alignment: .leading){
                                Text(event.nameOrganiser)
                                    .modifier(h5())
                                Text("\(event.age) años")
                                    .modifier(body2())
                            }
                        }
                        .onTapGesture {
                            self.viewState = 1
                        }
                        .background(
                            NavigationLink(destination: UserDetailView(idUser: event.idOrganiser), tag: 1, selection: $viewState) { EmptyView() }.opacity(0))
                        Spacer()
                    }
                    .padding(.horizontal, Constants.paddingGabatx10)
                    .padding(.bottom, Constants.paddingGabatx)

                }

                VStack{
                    Text(event.title)
                        .modifier(h4())
                        .padding(.top, 12)
                        .padding(.bottom, 1)
                        .foregroundColor(Color(LocalizedColor.black))

                    Text(event.dateStartTime.stringToDate()?.toEventDetail() ?? "No hay fecha")
                        .padding(.bottom, 15)
                        .foregroundColor(Color(LocalizedColor.black))
                        .modifier(body1())
                }
                .frame(maxWidth: .infinity)
                .background(Color(LocalizedColor.backgroundTittleEvent))
                .cornerRadius(Constants.cornerRadius)
                // Coge el ancho máximo

                HStack{
                    AsyncImage(url: URL(string: event.photoEvent)) { image in
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
                .frame(maxWidth: .infinity, maxHeight: 200)
                .cornerRadius(Constants.cornerRadius)
                .clipped(antialiased: true)
            }
            .padding(.horizontal, Constants.paddingEventItemInternal)
            .padding(.bottom, Constants.paddingEventItemInternal)
        }
        .cornerRadius(Constants.cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: Constants.cornerRadius).stroke(Constants.borderColor, lineWidth: Constants.lineWidth)
        )
        .background(.white)
        .background(
            NavigationLink(destination: EventDetailView(idOrganizer: event.idOrganiser, idEvent: event.id), tag: 2, selection: $viewState) { EmptyView()}.opacity(0))
        .onTapGesture {
            self.viewState = 2
        }

    }
}

struct EventItem_Previews: PreviewProvider {
    static var previews: some View {
        EventItem(event: DateFake.eventCell)
    }
}
