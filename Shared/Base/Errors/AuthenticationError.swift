//
//  AuthenticationError.swift
//  Anime-Quotes
//
//  Created by Łukasz Stachnik on 05/03/2022.
//

import Foundation

enum AuthenticationError: Error, LocalizedError, Identifiable {
    case invalidCredentials
    case deniedAccess
    case noFaceIdEnrolled
    case noFingerprintEnrolled
    case biometrictError
    case credentialsNotSaved
    
    var id: String {
        self.localizedDescription
    }
    
    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return NSLocalizedString("Either your email or password are incorrect. Try again.", comment: "")
        case .deniedAccess:
            return NSLocalizedString("You have denied access. Please go to the settings app and locate this application. Then turn on Face ID on.", comment: "")
        case .noFaceIdEnrolled:
            return NSLocalizedString("You have not registered any Face Ids yet", comment: "")
        case .noFingerprintEnrolled:
            return NSLocalizedString("You have not registered any fingerprints yet.", comment: "")
        case .biometrictError:
            return NSLocalizedString("You face or fingerprint were not recognized. ", comment: "")
        case .credentialsNotSaved:
            return NSLocalizedString("Your credentials have not been saved. Do you want to save them after the next successful login?", comment: "")
        }
    }
}
