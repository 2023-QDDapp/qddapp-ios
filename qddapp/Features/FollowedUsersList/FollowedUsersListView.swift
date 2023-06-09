//
//  FollowedUsersList.swift
//  qddapp
//
//  Created by gabatx on 30/5/23.
//

import SwiftUI

struct FollowedUsersListView: View {

    @StateObject var followedUsersListViewModel = FollowedUsersListViewModel()

    
    var body: some View {

        ZStack {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(followedUsersListViewModel.followedUsersList) { user in
                    FollowedUserCell(followedUser: user)
                        .navigationTitle("Siguiendo")
                        .environmentObject(followedUsersListViewModel)
                }
                Spacer()
            }

            .padding(Constants.paddinGeneral)
            .onAppear(){
                Task{
                    await followedUsersListViewModel.getFollowedUsersList()
                }
            }

            if followedUsersListViewModel.isLoading {
                ProgressView().scaleEffect(1.2)
            }
        }
    }
}

struct FollowedUsersListView_Previews: PreviewProvider {
    static var previews: some View {
        FollowedUsersListView()
    }
}
