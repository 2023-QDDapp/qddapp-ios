//
//  RatingStarts.swift
//  qddapp
//
//  Created by gabatx on 24/4/23.
//

import SwiftUI

struct RatingStarts: View {

    @ObservedObject var userDetailViewModel: UserDetailViewModel

    var size: CGFloat = 0
    var rating: Double = 0


    var body: some View {
        HStack(alignment: .center){
            //Spacer()
            userDetailViewModel.starRatingView(for: rating, size: size)
            Spacer()
        }
    }
}

struct RatingStarts_Previews: PreviewProvider {

    static var previews: some View {
        RatingStarts(userDetailViewModel: UserDetailViewModel())
                .environmentObject(UserDetailViewModel())
    }
}
