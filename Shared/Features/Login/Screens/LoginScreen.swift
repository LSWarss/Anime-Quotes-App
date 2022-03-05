//
//  LoginScreen.swift
//  Anime-Quotes
//
//  Created by Łukasz Stachnik on 05/03/2022.
//

import SwiftUI

struct LoginScreen: View {
    @StateObject private var loginVM = LoginViewModelImpl(
        authService: AuthServiceImpl())
    @EnvironmentObject var authenticator: AuthenthicationViewModelImpl
    
    var body: some View {
        NavigationView {
            switch loginVM.state {
            case .loading:
                LoadingView(text: "Loging in...")
            default:
                VStack(spacing: 32){
                    AsyncImage(url: URL(string: "https://res.cloudinary.com/sfp/image/upload/w_200,f_auto/cprd/images/ste/0e59ca77-6ae7-4f72-94eb-d50f9dc9ca19.png"))
                        .clipShape(Circle())
                        .shadow(radius: 10)
                    loginForm
                }
                    .navigationTitle("Weeb Anime Quotes")
                    .alert("Error",
                           isPresented: $loginVM.hasError,
                           presenting: loginVM.state) { detail in
                        
                    } message: { detail in
                        if case let .failed(error) = detail {
                            Text(error.localizedDescription)
                        }
                    }
            }
        }
    }
}

private extension LoginScreen {
    
    private var header: some View {
        Text("Anime Weeb's Quotes 📖")
            .font(.title)
            .fontWeight(.bold)
    }
    
    private var loginForm: some View {
        VStack(){
            TextField("Email Address", text: $loginVM.credentials.email)
                .keyboardType(.emailAddress)
                .disableAutocorrection(true)
            SecureField("Password", text: $loginVM.credentials.password)
                .disableAutocorrection(true)
            Button {
                Task {
                    authenticator.updateValidation(success: await loginVM.login())
                }
            } label: {
                Text("Log in 📲")
                    .font(.title2)
                    .fontWeight(.black)
            }
            .disabled(loginVM.loginDisabled)
        }
        .padding()
        .buttonStyle(.borderedProminent)
     
    }
    
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}
