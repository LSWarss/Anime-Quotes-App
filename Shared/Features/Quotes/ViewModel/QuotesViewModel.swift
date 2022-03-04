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

@MainActor
class QuotesViewModelImpl : QuotesViewModel {
    
    @Published private(set) var quotes: [Quote] = []
    private let quotesService: QuotesService
    
    init(quotesService: QuotesService) {
        self.quotesService = quotesService
    }
    
    func getRandomQuotes() async {
        do {
            self.quotes = try await quotesService.fetchRandomQuotes()
        } catch {
            print(error)
        }
    }
}
