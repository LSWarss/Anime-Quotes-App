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
}

final class LoginViewModelImpl : LoginViewModel {
    
    enum State {
        case na
        case loading
        case success
        case failed(error: Error)
    }
    
    @Published private(set) var state: State = .na
    @Published var hasError: Bool = false
    @Published var credentials = Credentials()
    
    private let authService: AuthService
    
    var loginDisabled: Bool {
        credentials.email.isEmpty || credentials.password.isEmpty // change to combine func
    }
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    func login() async -> Bool {
    
        self.state = .loading
        self.hasError = false
        
        do {
            let auth = try await authService.login(with: self.credentials)
            DispatchQueue.main.async {
                self.state = .success
            }
            return auth
        } catch {
            self.state = .failed(error: error)
            self.hasError = true
        }
        
        return false
    }
}
