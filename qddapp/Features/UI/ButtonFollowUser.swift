//
//  ButtonFollowUser.swift
//  qddapp
//
//  Created by gabatx on 10/5/23.
//

import SwiftUI

struct ButtonFollowUser: View {

    @EnvironmentObject var userDetailViewModel: UserDetailViewModel
    @State private var colorBackgroundButton = Color(LocalizedColor.secondary)
    

    var idUser: Int

    init(idUser: Int) {
        self.idUser = idUser
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Button(action: {
                userDetailViewModel.isFollowUser.toggle() // Colocar acción
            }, label: {
                HStack{
                    Image(systemName: userDetailViewModel.isFollowUser ? "checkmark.rectangle.fill" : "plus.rectangle.fill") // Siguiendo: checkmark.rectangle.fill
                        .foregroundColor(.white)
                    Text(userDetailViewModel.isFollowUser ? "Siguiendo" : "Seguir")
                        .modifier(body1(color: .white))
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(5)
                .background(userDetailViewModel.isFollowUser ? Color(LocalizedColor.primary) : Color(LocalizedColor.secondary))
                .cornerRadius(Constants.cornerRadius)
            })
            .onChange(of: userDetailViewModel.isFollowUser) { newValue in
                if newValue {
                    Task{
                        await userDetailViewModel.followUser(idUser: idUser)
                    }
                } else {
                    Task{
                        await userDetailViewModel.unfollowUser(idUser: idUser)
                    }
                }
            }
            .onAppear() {
                Task{
                    await userDetailViewModel.verifyFollowing(idUser: idUser)
                }
            }
        }
    }
}

struct ButtonFollowUser_Previews: PreviewProvider {
    static var previews: some View {
        ButtonFollowUser(idUser: 0)
    }
}
