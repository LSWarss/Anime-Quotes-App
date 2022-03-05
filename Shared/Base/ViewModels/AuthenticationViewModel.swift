//
//  AuthenticationViewModel.swift
//  Anime-Quotes
//
//  Created by Łukasz Stachnik on 05/03/2022.
//

import LocalAuthentication

protocol AuthenticationViewModel: ObservableObject {
    var isValidated: Bool { get }
    func updateValidation(success: Bool)
    func biometricType() -> BiometricType
}

final class AuthenthicationViewModelImpl : AuthenticationViewModel {
    @Published private(set) var isValidated = false
    @Published private(set) var isAuthorized = false
    
    func updateValidation(success: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.isValidated = success
        }
    }
    
    func biometricType() -> BiometricType {
        let authContext = LAContext()
        let _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch authContext.biometryType {
        case .none:
            return .none
        case .touchID:
            return .touch
        case .faceID:
            return .face
        @unknown default:
            return .none
        }
    }
    
    func requestBiometricUnlock() async throws -> Credentials {
//        let credentials: Credentials? = Credentials(email: "anything", password: "password")
//        let credentials: Credentials? = nil
        let credentials = KeychainStorage.getCredential()
        guard let credentials = credentials else {
            throw AuthenticationError.credentialsNotSaved
        }
        
        let context = LAContext()
        var error: NSError?
        let canEvaluate = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        try evaluateError(error, for: context)
        
        if canEvaluate {
            if context.biometryType != .none {
                if try await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Need to access credentials") {
                    return credentials
                } else {
                    throw AuthenticationError.biometrictError
                }
            }
        }
        return credentials
    }
}

private extension AuthenthicationViewModelImpl {
    
    func evaluateError(_ error: NSError?, for context: LAContext) throws {
        if let error = error {
            switch error.code {
            case -6:
                throw AuthenticationError.deniedAccess
            case -7:
                if context.biometryType == .faceID {
                    throw AuthenticationError.noFaceIdEnrolled
                } else {
                    throw AuthenticationError.noFingerprintEnrolled
                }
            default:
                throw AuthenticationError.biometrictError
            }
        }
    }
}
