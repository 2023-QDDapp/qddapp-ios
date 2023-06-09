//
//  RatingView.swift
//  qddapp
//
//  Created by gabatx on 24/4/23.
//

import SwiftUI

struct RatingView: View {

    var rating: RatingModel
    @ObservedObject var userDetailViewModel: UserDetailViewModel

    var body: some View {
        NavigationLink(destination: UserDetailView(idUser: rating.idUser)) {
            HStack(alignment: .top) {
                ImageRoundedItem(photo: rating.photo, width: 60, height: 60)
                VStack(alignment: .leading, spacing: 2) {
                    Text(rating.name)
                        .modifier(h5())
                        .foregroundColor(Color(LocalizedColor.black))
                    RatingStarts(userDetailViewModel: userDetailViewModel, size: 10, rating: rating.rating ?? 0)
                    Text(rating.message)
                        .modifier(body1())
                        .multilineTextAlignment(.leading)
                }
                Spacer()
            }
            .redacted(reason: userDetailViewModel.isLoading ? .placeholder : [])
        }
    }
}


struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(rating: DateFake.ratingUser, userDetailViewModel: UserDetailViewModel())
            .environmentObject(UserDetailViewModel())
    }
}
