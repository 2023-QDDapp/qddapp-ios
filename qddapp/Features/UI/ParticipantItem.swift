//
//  ParticipantItem.swift
//  qddapp
//
//  Created by gabatx on 24/4/23.
//

import SwiftUI

struct ParticipantItem: View {

    var user: ParticipantEventModel

    var body: some View {
        HStack(spacing: 15) {
            ImageRoundedItem(photo: user.photo, width: 40, height: 40)

            VStack(alignment: .leading, spacing: 2) {
                Text(user.name)
                    .bold()
                    .modifier(body1())
                Text("\(Constants.randomAge()) años")
                    .font(.caption)
                    .modifier(caption())
            }
            .foregroundColor(Color(LocalizedColor.black))
            Spacer()
            ZStack{
                Image(systemName: "info.circle")
                    .foregroundColor(Color(LocalizedColor.primary))
            }
        }
        .padding(.vertical, 5)
    }
}

struct ParticipantItem_Previews: PreviewProvider {
    static var previews: some View {
        ParticipantItem(user: DateFake.participant)
    }
}
