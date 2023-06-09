//
//  EventHeldCell.swift
//  qddapp
//
//  Created by gabatx on 8/6/23.
//

import SwiftUI

struct EventHeldCell: View {

    var event: EventHeldCellModel

    init(event: EventHeldCellModel) {
        self.event = event
    }

    var body: some View {

        NavigationLink(destination: EventDetailView(idOrganizer: event.idOrganizer, idEvent: event.idEvent)) {
            HStack(spacing: 18){
                ImageRoundedItem(photo: event.photo, width: 60, height: 60)
                        .overlay(alignment: .topTrailing) {
                            if isUserLogin() {
                                Image(systemName: "star.fill")
                                        .styleBasicImageLogo()
                                        .frame(width: 20)
                                        .scaledToFill()
                                        .padding(.leading)
                                        .foregroundColor(Color(LocalizedColor.primary))
                            }
                        }
                VStack(alignment: .leading, spacing: 5){
                    Text(event.titleEvent)
                            .modifier(h5())
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)
                    Text(event.dateStart.stringToFormatterDateString())
                            .modifier(body2())
                }
                Spacer()
            }

            .frame(height: 80)
            .borderStyle()
        }
        .background(.white)
    }
    func isUserLogin() -> Bool {
        guard let userID = UserDefaultsManager.shared.userID else {
            return false
        }
        return Int(userID)! == event.idOrganizer
    }
}

struct EventHeldCell_Previews: PreviewProvider {
    static var previews: some View {
        EventHeldCell(event: DateFake.eventHeldCell)
            .environmentObject(EventsHeldViewModel())
    }
}
