//
//  AuthenticationViewModel.swift
//  Anime-Quotes
//
//  Created by Łukasz Stachnik on 05/03/2022.
//

import Foundation
import SwiftUI

enum AuthenticationError: Error, LocalizedError, Identifiable {
    case invalidCredentials
    
    var id: String {
        self.localizedDescription
    }
    
    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return NSLocalizedString("Either your email or password are incorrect. Try again.", comment: "")
        }
    }
}

protocol AuthenticationViewModel: ObservableObject {
    var isValidated: Bool { get }
    func updateValidation(success: Bool)
}

final class AuthenthicationViewModelImpl : AuthenticationViewModel {
    @Published private(set) var isValidated: Bool = false
    
    func updateValidation(success: Bool) {
        withAnimation {
            isValidated = success
        }
    }
}
