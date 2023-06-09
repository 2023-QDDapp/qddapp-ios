//  UserDetailView.swift
//
//  qddapp
//
//  Created by gabatx on 23/4/23.
//

import SwiftUI
import WrappingHStack

struct UserDetailView: View {
    
    var idUser: Int
    @StateObject var userDetailViewModel = UserDetailViewModel()
    @State var viewState: Int? = 0
    @State var selectedUserID = 0

    init(idUser: Int) {
        self.idUser = idUser
    }

    var body: some View {

        ScrollView{
            VStack(alignment: .leading, spacing: 20){
                HStack(spacing: 20) {
                    ImageRoundedItem(photo: userDetailViewModel.user?.photo ?? "", width: 140, height: 140)

                    VStack(alignment: .leading) {
                        Text(userDetailViewModel.user?.name ?? "Sin nombre" )
                            .modifier(h3())
                            .lineLimit(3)
                        Text("\(String(describing: userDetailViewModel.user?.age ?? 0)) años")
                            .modifier(body1())
                        if !userDetailViewModel.isProfileUserLogin {
                            ButtonFollowUser(idUser: idUser)
                                .environmentObject(userDetailViewModel)
                        }
                    }
                    Spacer()
                }
                .padding(.top)

                LineSeparator()
                
                VStack(alignment: .leading){
                    HStack {
                        Text("Intereses")
                            .modifier(h4())
                            .foregroundColor(Color(LocalizedColor.black))
                        Spacer()
                    }

                    HStack{
                        WrappingHStack(userDetailViewModel.user?.interests ?? [], lineSpacing: 10) { interest in
                            Text(interest.name)
                                .lineLimit(1)
                                .padding(7)
                                .background(Color(LocalizedColor.primary))
                                .cornerRadius(20)
                        }
                        Spacer()
                    }
                    .modifier(body1(color: .white))

                    VStack(alignment: .leading, spacing: 18){
                        Text("¿Sobre mi?")
                            .modifier(h4())
                            .foregroundColor(Color(LocalizedColor.black))
                            .padding(.top, 15)
                        Text(userDetailViewModel.user?.description ?? "Nada que decir")
                            .foregroundColor(Color(LocalizedColor.black))
                            .modifier(body1())
                    }
                }
                .padding(.horizontal, 8)

                LineSeparator()

                VStack(alignment: .leading, spacing: 10){
                    Text("Valoraciones")
                        .modifier(h4())
                        .foregroundColor(Color(LocalizedColor.black))
                    RatingStarts(userDetailViewModel: userDetailViewModel, size: 35, rating: userDetailViewModel.getAverageRating(ratings: userDetailViewModel.user?.ratings ?? []))
                }
                .padding(.horizontal, 8)

                if let ratings = userDetailViewModel.user?.ratings {
                    if ratings.count > 0 {
                        ForEach(ratings, id: \.idUser) { rating in
                            NavigationLink(destination: UserDetailView(idUser: rating.idUser)) {
                                RatingView(rating: rating, userDetailViewModel: userDetailViewModel)
                                    .padding(.vertical, 14)
                                    .cornerRadius(10)
                                    .environmentObject(userDetailViewModel)
                            }
                        }
                    } else {
                        Text("Sin valoraciones")
                            .modifier(h3())
                            .padding(.horizontal, 8)
                    }
                }

                NavigationLink(destination: SettingsView().navigationTitle("Ajustes"), isActive: $userDetailViewModel.showSettingsView, label: {})
            }
            .redacted(reason: userDetailViewModel.isLoading ? .placeholder : [])
            .navigationBarTitle("Perfil", displayMode: .inline)
            // Fondo transparente
        }
        .padding(.horizontal)
        .background(.clear)
        .onAppear(){
            Task{
                await userDetailViewModel.getUserById(id: idUser)
                // await userDetailViewModel.getRatingsUserById(id: idUser)
            }
        }
        .onDisappear(){
            userDetailViewModel.isProfileUserLogin = false
        }
        .navigationBarItems(trailing: userDetailViewModel.isProfileUserLogin ? HStack{
            Button {
                userDetailViewModel.showSettingsView = true
            } label: {
                Image(LocalizedImage.settingProfile)
                    .styleIconSVG()
                    .frame(width: 30, height: 30)
                    .padding(.trailing, 2)
            }
        } : nil )
    }
}

struct UserDetailView_Previews: PreviewProvider {
    static var previews: some View {
        UserDetailView(idUser: 0)
            .environmentObject(UserDetailViewModel())
    }
}
