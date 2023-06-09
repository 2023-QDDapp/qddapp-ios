//
//  EventHeldListSkeleton.swift
//  qddapp
//
//  Created by gabatx on 8/6/23.
//

import SwiftUI

struct EventHeldListSkeleton: View {

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ScrollView{
                ForEach(1...10, id: \.self) {_ in
                    EventHeldCell(event: DateFake.eventHeldCell)
                        .redacted(reason: .placeholder)
                }
            }
        }
        .padding(.horizontal, Constants.paddingComponent)
        .padding(.top, Constants.paddingComponent)
    }
}

struct EventHeldListSkeleton_Previews: PreviewProvider {
    static var previews: some View {
        EventHeldListSkeleton()
    }
}
