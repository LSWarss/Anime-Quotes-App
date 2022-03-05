//
//  Anime_QuotesApp.swift
//  Shared
//
//  Created by Łukasz Stachnik on 04/03/2022.
//

import SwiftUI

@main
struct AnimeQuotesApp: App {
    @StateObject var authentication = AuthenthicationViewModelImpl()
    
    var body: some Scene {
        WindowGroup {
            if authentication.isValidated {
                QuoteScreen()
                    .environmentObject(authentication)
            } else {
                LoginScreen()
                    .environmentObject(authentication)
            }
        }
    }
}
