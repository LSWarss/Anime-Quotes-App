//
//  AuthService.swift
//  Anime-Quotes
//
//  Created by Łukasz Stachnik on 05/03/2022.
//

import Foundation
import SwiftUI

protocol AuthService {
    func login(with credentials: Credentials) async throws -> Bool
}

struct AuthServiceImpl: AuthService {
    
    func login(with credentials: Credentials) async throws -> Bool {
        try await Task.sleep(nanoseconds: UInt64(1 * Double(NSEC_PER_SEC)))
        
        if credentials.password == "password" {
            return true
        } else {
            throw AuthenticationError.invalidCredentials
        }
    }
}
