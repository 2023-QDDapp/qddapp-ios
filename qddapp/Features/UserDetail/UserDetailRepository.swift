//
//  UserDetailRepository.swift
//  qddapp
//
//  Created by gabatx on 23/4/23.
//

import Foundation

protocol UserDetailRepositoryProtocol {
    func getUserbyId(id: Int) async -> UserModel?
    func getRatingsUserById(id: Int) async -> [RatingModel]?
    func followUser(idUser: Int) async -> MessageResponseModel
    func unfollowUser(idUser: Int) async -> MessageResponseModel
    func verifyFollowing(idUser: Int) async -> MessageResponseModel
}

class UserDetailRespositoryApiRest {
    var requestManager: NetworkManager = NetworkManager(urlBase: Constants.urlBase)
}

extension UserDetailRespositoryApiRest:UserDetailRepositoryProtocol {

    func followUser(idUser: Int) async -> MessageResponseModel {
        let endPoint = "users/\(idUser)/follow"
        
        do {
            return try await requestManager.post(endPoint: endPoint, body: IdUserForBodyModel(id: idUser), token: UserDefaultsManager.shared.userToken!)
        } catch {
            print("Error en la obtención de datos: \(error)")
            return DateFake.messageResponseModel
        }
    }

    func unfollowUser(idUser: Int) async -> MessageResponseModel {
            let endPoint = "users/\(idUser)/unfollow"

            do {
                return try await requestManager.post(endPoint: endPoint, body: IdUserForBodyModel(id: idUser), token: UserDefaultsManager.shared.userToken!)
            } catch {
                print("Error en la obtención de datos: \(error)")
                return DateFake.messageResponseModel
            }
        }

    func getUserbyId(id: Int) async -> UserModel? {
        let endPoint = "users/\(id)"
        do {
            return try await requestManager.get(endPoint: endPoint)
        } catch {
            print("Error en la obtención de datos: \(error)")
            return DateFake.user
        }
    }

    func verifyFollowing(idUser: Int) async -> MessageResponseModel {
        let endPoint = "users/\(idUser)/verifyFollowing"
        do {
            return try await requestManager.post(endPoint: endPoint, body: IdUserForBodyModel(id: idUser), token: UserDefaultsManager.shared.userToken!)
        } catch {
            print("Error en la obtención de datos: \(error)")
            return MessageResponseModel(message: "Ha habido un error en la petición")
        }
    }

    func getRatingsUserById(id: Int) async -> [RatingModel]? {
        return []
    }
}

class UserDetailRespositoryMock: UserDetailRepositoryProtocol {
    func verifyFollowing(idUser: Int) async -> MessageResponseModel {
        return MessageResponseModel(message: "Ha habido un error en la petición")
    }

    let requestManager = JsonManager()

    func followUser(idUser: Int) async -> MessageResponseModel {
        return DateFake.messageResponseModel
    }

    func unfollowUser(idUser: Int) async -> MessageResponseModel {
        return DateFake.messageResponseModel
    }

    func getUserbyId(id: Int) async -> UserModel? {
        let json = "Usuarios"
        let users: [UserModel] = requestManager.get(json: json) ?? []
        return users.first { $0.id == id }
    }

    func getRatingsUserById(id: Int) async -> [RatingModel]? {
        let json = "Resenas"
        let ratings: [RatingModel] = requestManager.get(json: json) ?? []
        return ratings.filter { $0.idUser == id }
    }
}


