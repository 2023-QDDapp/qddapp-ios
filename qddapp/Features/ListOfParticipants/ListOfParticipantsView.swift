//
//  ListOfParticipantsView.swift
//  qddapp
//
//  Created by gabatx on 24/4/23.
//

import SwiftUI

struct ListOfParticipantsView: View {

    @EnvironmentObject var listOfParticipantsViewModel: ListOfParticipantsViewModel
    @State var viewState: Int? = 0

    var idUserOrganiserEvent: Int = 2
    var participants: [ParticipantEventModel]

    init(participants: [ParticipantEventModel]) {
        self.participants = participants
    }

    var body: some View {
        VStack{
           ScrollView {
               ForEach(participants){ participant in
                     ParticipantItem(user: participant)
                       .background(
                           NavigationLink(destination: UserDetailView(idUser: participant.id), tag: 1, selection: $viewState) { EmptyView() }.opacity(0))
               }
           }
           .padding(.horizontal)
           .listStyle(.plain)// Elimina el color de fondo
        }
        .navigationTitle("Asistentes")
        .task {
            await listOfParticipantsViewModel.getParticipants(id: idUserOrganiserEvent)
        }
        .onTapGesture {
            self.viewState = 1
        }

    }
}

struct ListOfParticipantsView_Previews: PreviewProvider {
    static var previews: some View {
        ListOfParticipantsView(participants: [DateFake.participant])
            .environmentObject(ListOfParticipantsViewModel())
    }
}


