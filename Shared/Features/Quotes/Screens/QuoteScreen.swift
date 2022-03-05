//
//  QuoteScreen.swift
//  Anime-Quotes
//
//  Created by Łukasz Stachnik on 04/03/2022.
//

import SwiftUI

struct QuoteScreen: View {
    
    @StateObject private var vm = QuotesViewModelImpl(
        quotesService: QuotesServiceImpl())
    @EnvironmentObject private var authenticator: AuthenthicationViewModelImpl
    
    var body: some View {
        NavigationView {
            switch vm.state {
            case .loading:
                LoadingView(text: "Fetching Quotes")
            case .success(let data):
                List {
                    ForEach(data, id: \.anime) { item in
                        NavigationLink {
                            
                        } label: {
                            QuoteView(item: item)
                        }
                    }
                }
                .listStyle(.plain)
                .navigationTitle("Quotes")
                .toolbar {
                    Button("Log Out") {
                        authenticator.updateValidation(success: false)
                    }
                }
            default:
                EmptyView()
            }
        }
        .task {
            await vm.getRandomQuotes()
        }
        .alert("Error",
               isPresented: $vm.hasError,
               presenting: vm.state) { detail in
            
            Button("Retry") {
                Task {
                    await vm.getRandomQuotes()
                }
            }
        } message: { detail in
            if case let .failed(error) = detail {
                Text(error.localizedDescription)
            }
        }
    }
}

struct QuoteScreen_Previews: PreviewProvider {
    static var previews: some View {
        QuoteScreen()
    }
}
