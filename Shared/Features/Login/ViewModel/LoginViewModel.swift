//
//  LoginViewModel.swift
//  Anime-Quotes
//
//  Created by Łukasz Stachnik on 05/03/2022.
//

import Foundation

protocol LoginViewModel: ObservableObject {
    var loginDisabled: Bool { get }
    var hasError: Bool { get }
    func login() async -> Bool
    func setFailure(with error: Error)
}

final class LoginViewModelImpl : LoginViewModel {
    
    enum State {
        case na
        case loading
        case success
        case failed(error: Error)
    }
    
    @Published private(set) var state: State = .na
    @Published var hasError = false
    @Published var credentials = Credentials()
    @Published var storeCredentialsNext = true  
    
    private let authService: AuthService
    
    var loginDisabled: Bool {
        credentials.email.isEmpty || credentials.password.isEmpty // change to combine func
    }
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    func setFailure(with error: Error) {
        DispatchQueue.main.async {
            self.state = .failed(error: error)
        }
    }
    
    func login() async -> Bool {
        DispatchQueue.main.async {
            self.state = .loading
            self.hasError = false
        }
        do {
            let auth = try await authService.login(with: self.credentials)
            
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                if self.storeCredentialsNext {
                    if KeychainStorage.saveCredentials(self.credentials) {
                        self.storeCredentialsNext = false
                    }
                }
                self.state = .success
            }
            return auth
        } catch {
            DispatchQueue.main.async {
                self.state = .failed(error: error)
                self.hasError = true
            }
        }
        
        return false
    }
}
