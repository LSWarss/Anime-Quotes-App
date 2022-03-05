//
//  KeychainStorage.swift
//  Anime-Quotes
//
//  Created by Łukasz Stachnik on 05/03/2022.
//

import Foundation
import SwiftKeychainWrapper

enum KeychainStorage {
    static let key = "credentials"
    
    static func getCredential() -> Credentials? {
        guard let myCredentials = KeychainWrapper.standard.string(forKey: Self.key) else {
            return nil
        }
        
        return Credentials.decoded(myCredentials)
    }
    
    static func saveCredentials(_ credentials: Credentials) -> Bool {
        return KeychainWrapper.standard.set(credentials.encoded(), forKey: Self.key)
    }
}
