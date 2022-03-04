//
//  QuotesViewModel.swift
//  Anime-Quotes
//
//  Created by Łukasz Stachnik on 04/03/2022.
//

import Foundation

protocol QuotesViewModel: ObservableObject {
    func getRandomQuotes() async
}

@MainActor //that ensures that changes to state are made on main thread
class QuotesViewModelImpl : QuotesViewModel {
    
    enum State {
        case na
        case loading
        case success(data: [Quote])
        case failed(error: Error)
    }
    
    @Published private(set) var state: State = .na
    @Published var hasError: Bool = false
    
    private let quotesService: QuotesService
    
    init(quotesService: QuotesService) {
        self.quotesService = quotesService
    }
    
    func getRandomQuotes() async {
        
        self.state = .loading
        self.hasError = false
        
        do {
            let quotes = try await quotesService.fetchRandomQuotes()
            self.state = .success(data: quotes)
        } catch {
            self.state = .failed(error: error)
            self.hasError = true
        }
    }
}
