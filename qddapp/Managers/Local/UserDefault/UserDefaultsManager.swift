//
//  UserDefaultsManager.swift
//  qddapp
//
//  Created by gabatx on 5/6/23.
//

import Foundation

class UserDefaultsManager {
    private let userDefaults: UserDefaults
    private let idKey = Constants.userId
    private let tokenKey = Constants.tokenName
    private let isLoginKey = Constants.isLogin

    static let shared = UserDefaultsManager()

    private init() {
        userDefaults = UserDefaults.standard
    }

    var userID: String? {
        get {
            return userDefaults.string(forKey: idKey)
        }
        set {
            userDefaults.set(newValue, forKey: idKey)
            userDefaults.synchronize()
        }
    }

    var userToken: String? {
        get {
            return userDefaults.string(forKey: tokenKey)
        }
        set {
            userDefaults.set(newValue, forKey: tokenKey)
            userDefaults.synchronize()
        }
    }

    var isUserLoggedIn: Bool {
        get {
            return userDefaults.bool(forKey: isLoginKey)
        }
        set {
            userDefaults.set(newValue, forKey: isLoginKey)
            userDefaults.synchronize()
        }
    }
}

