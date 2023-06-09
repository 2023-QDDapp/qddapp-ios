//
//  ListOfParticipantsViewModel.swift
//  qddapp
//
//  Created by gabatx on 24/4/23.
//

import Foundation

@MainActor
class ListOfParticipantsViewModel: ObservableObject{

    var repository: ListOfParticipantsRepositoryProtocol = ListOfParticipantsRepositoryMock()

    @Published var participants: [UserModel] = []

    func getParticipants(id: Int) async {
        participants = await repository.getParticipants(id: id) ?? []
    }
}
