//
//  ButtonJoinEvent.swift
//  qddapp
//
//  Created by gabatx on 20/4/23.
//

import SwiftUI

struct ButtonJoinEvent: View {

    @EnvironmentObject var eventDetailViewModel: EventDetailViewModel
    @EnvironmentObject var popupViewModel: PopupViewModel

    @State private var colorTextButton = Color.white

    var body: some View {

        ZStack(alignment: .bottom) {
            Button(action: {
                if !eventDetailViewModel.isLoading {
                    Task{
                        await eventDetailViewModel.actionButtonEvent()
                    }
                }
            }, label: {
                Text(eventDetailViewModel.buttonTitle)
                    .redacted(reason: eventDetailViewModel.isLoadingRequestRelationship ? .placeholder : [])
                    .modifier(h4(color: colorTextButton))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .background(eventDetailViewModel.buttonColor)
                    .cornerRadius(10)
            })
            .padding()
            .background(.white)
            .frame(maxWidth: .infinity, alignment: .center)
            .animation(.easeInOut)
        }
        .redacted(reason: eventDetailViewModel.isLoading ? .placeholder : [])
        .onChange(of: eventDetailViewModel.messagePopup) { message in
            popupViewModel.popupBasic(titlePopup: message, titleButton: "Aceptar") {
                
            }
        }
    }
}

struct ButtonJoinEvent_Previews: PreviewProvider {
    static var previews: some View {
        ButtonJoinEvent()
            .environmentObject(EventDetailViewModel())
            .environmentObject(PopupViewModel())
    }
}
