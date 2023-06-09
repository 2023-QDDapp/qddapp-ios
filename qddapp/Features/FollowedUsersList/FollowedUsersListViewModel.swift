//
//  FollowedUsersListViewModel.swift
//  qddapp
//
//  Created by gabatx on 30/5/23.
//

import Foundation

@MainActor
class FollowedUsersListViewModel: ObservableObject {

    let repository: FollowedUsersListRepositoryProtocol = FollowedUsersListRepositoryApiRest()
    let repositoryUser: UserDetailRepositoryProtocol = UserDetailRespositoryApiRest()

    @Published var followedUsersList: [FollowedUser] = DateFake.followedUser
    @Published var isLoading = false
    @Published var showPopup = false

    func getFollowedUsersList() async {
        isLoading = true
        followedUsersList = await repository.getFollowedUsersList()
        isLoading = false
    }

    func unfollowUser(idUser: Int) async {
        isLoading = true
        let result = await repositoryUser.unfollowUser(idUser: idUser).message
        isLoading = false
        if result.contains("Ya no sigues al usuario"){
            await getFollowedUsersList()
        }
     }

}
