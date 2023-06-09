//
//  FollowedUserCell.swift
//  qddapp
//
//  Created by gabatx on 31/5/23.
//

import SwiftUI

struct FollowedUserCell: View {

    @EnvironmentObject var popupViewModel: PopupViewModel
    @EnvironmentObject var followedUsersListViewModel: FollowedUsersListViewModel


    var followedUser: FollowedUser

    init(followedUser: FollowedUser) {
            self.followedUser = followedUser
        }

    var body: some View {
        ZStack {
            HStack(spacing: 15) {
                ImageRoundedItem(photo: followedUser.photo, width: 40, height: 40)
                NavigationLink(destination: UserDetailView(idUser: followedUser.id)) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(followedUser.name)
                            .bold()
                            .modifier(body1())
                        Text("\(Constants.randomAge()) años")
                            .font(.caption)
                            .modifier(caption())
                    }
                    .foregroundColor(Color(LocalizedColor.black))
                }
                Spacer()
                ZStack{
                    Button {
                        popupViewModel.popupBasic(titlePopup: "¿Dejar de seguir a \(followedUser.name)?", titleButton: "Dejar de seguir") {
                            Task{
                                await followedUsersListViewModel.unfollowUser(idUser: followedUser.id)
                            }
                        }
                    } label: {
                        Image("cerrar")
                            .styleBasicImageLogo(color: .red)
                            .frame(height:20)
                    }
                }
            }
            .padding(.vertical, 5)
        }


    }
}

struct FollowedUserCell_Previews: PreviewProvider {
    static var previews: some View {
        FollowedUserCell(followedUser: DateFake.followedUser[0])
                .environmentObject(PopupViewModel())
                .environmentObject(FollowedUsersListViewModel())
    }
}
