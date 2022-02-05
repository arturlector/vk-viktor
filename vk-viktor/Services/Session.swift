//
//  Session.swift
//  vk-viktor
//
//  Created by Artur Igberdin on 05.02.2022.
//

import Foundation
import SwiftKeychainWrapper

//Синглтон
final class Session {
    
    private init() {}
    
    static let shared = Session()
    
    var token: String {
        set {
            KeychainWrapper.standard.set(newValue, forKey: "com.vk.token")
        }
        get {
            return KeychainWrapper.standard.string(forKey: "com.vk.token") ?? ""
        }
    }
    
    var userId: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: "com.vk.userId")
        }
        get {
            return UserDefaults.standard.integer(forKey: "com.vk.userId")
        }
    }
    
    //TODO: - Решить как сохранять
    var expiresIn: Int = 0
    
}
