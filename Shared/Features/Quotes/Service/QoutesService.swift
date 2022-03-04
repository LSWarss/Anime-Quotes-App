//
//  QoutesService.swift
//  Anime-Quotes
//
//  Created by Łukasz Stachnik on 04/03/2022.
//

import Foundation

protocol QuotesService {
    func fetchRandomQuotes() async throws -> [Quote]
}

struct QuotesServiceImpl: QuotesService {
    
    enum QuoteServiceError: Error {
        case failed
        case failedToDecode
        case invalidStatusCode
    }
    
    func fetchRandomQuotes() async throws -> [Quote] {
        let url = URL(string: APIConstants.baseUrl.appending("/api/quotes"))
        
        let (data, response) = try await URLSession.shared.data(from: url!)
        
        guard let response = response as? HTTPURLResponse,
              response.statusCode == 200 else {
                  throw QuoteServiceError.invalidStatusCode
              }
        
        let decodedData = try JSONDecoder().decode([Quote].self, from: data)
        return decodedData
    }
}
