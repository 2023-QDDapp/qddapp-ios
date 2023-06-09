//
//  UserDetailViewModel.swift
//  qddapp
//
//  Created by gabatx on 23/4/23.
//

import Foundation
import SwiftUI

enum VerifyFollowingResponse: String {
    case follow = "Seguir"
    case unFollow = "Dejar de seguir"
}

@MainActor
class UserDetailViewModel: ObservableObject {

    var repository: UserDetailRepositoryProtocol = UserDetailRespositoryApiRest()
    
    @Published var user: UserModel?
    @Published var ratings: [RatingModel] = []
    @Published var isLoading = false
    @Published var isProfileUserLogin = false
    @Published var showUserDetaiView = false
    @Published var userAccountExist = true
    @Published var isFollowUser = false
    @Published var showSettingsView = false

    func getUserById(id: Int) async {
        isLoading = true
        user = await repository.getUserbyId(id: id)
        if Int(UserDefaultsManager.shared.userID!)! == id {
            isProfileUserLogin = true
        }
        isLoading = false
    }

    func getRatingsUserById(id: Int) async {
        ratings = await repository.getRatingsUserById(id: id) ?? []
    }

    // Función que pinta las estrellas dependiendo de la nota
    func starRatingView(for rating: Double, size: CGFloat) -> some View {
        guard rating.isFinite else {
            return AnyView(EmptyView())
        }

        let clampedRating = max(0, min(rating, 5))
        let fullStars = Int(clampedRating)
        let hasHalfStar = clampedRating - Double(fullStars) >= 0.5

        return AnyView(
            HStack {
                ForEach(0..<5) { index in
                    if index < fullStars {
                        Image(systemName: "star.fill")
                            .font(.system(size: size))
                            .foregroundColor(Color(LocalizedColor.primary))
                    } else if index == fullStars && hasHalfStar {
                        Image(systemName: "star.leadinghalf.filled")
                            .font(.system(size: size))
                            .foregroundColor(Color(LocalizedColor.primary))
                    } else {
                        Image(systemName: "star")
                            .font(.system(size: size))
                            .foregroundColor(Color(LocalizedColor.primary))
                    }
                }
            }
        )
    }

    // Función que calcula la media de todos los ratings
    func getAverageRating(ratings: [RatingModel]) -> Double {
        ratings.reduce(0) { $0 + ($1.rating ?? 0) } / Double(ratings.count)
    }

    func followUser(idUser: Int) async {
        let result = await repository.followUser(idUser: idUser)
        print(result)
    }

    func unfollowUser(idUser: Int) async {
        let result = await repository.unfollowUser(idUser: idUser)
        print(result)
     }

    func verifyFollowing(idUser: Int) async {
        let result = await repository.verifyFollowing(idUser: idUser).message
        if result == VerifyFollowingResponse.follow.rawValue {
            isFollowUser = false
        } else {
            isFollowUser = true
        }
    }
}
