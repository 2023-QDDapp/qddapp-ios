//
//  EventListSkeleton.swift
//  qddapp
//
//  Created by gabatx on 23/5/23.
//

import SwiftUI

struct EventListSkeleton: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ScrollView{
                ForEach(1...10, id: \.self) {_ in
                    EventItem(event: DateFake.eventCell)
                        .redacted(reason: .placeholder)
                }
            }
        }
        .padding(.horizontal, Constants.paddingComponent)
        .padding(.top, Constants.paddingComponent)
    }
}

struct EventListSkeleton_Previews: PreviewProvider {
    static var previews: some View {
        EventListSkeleton()
    }
}
