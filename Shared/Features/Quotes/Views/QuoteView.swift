//
//  QuoteView.swift
//  Anime-Quotes
//
//  Created by Łukasz Stachnik on 04/03/2022.
//

import SwiftUI

struct QuoteView: View {
    
    let item: Quote
    
    var body: some View {
        VStack(alignment: .leading,
               spacing: 8) {
            HStack {
                Image(systemName: "tv")
                    .font(.system(size: 12, weight: .black))
                Text(item.anime)
                    .font(.callout)
            }
            
            Text(makeAttributedString(title: "Character",
                                      label: item.character))
            Text(makeAttributedString(title: "Quotes",
                                      label: item.quote))
        }
        .padding()
        .foregroundColor(.black)
    }
}


extension QuoteView {
    
    private func makeAttributedString(title: String, label: String) -> AttributedString {
        
        var string = AttributedString("\(title): \(label)")
        string.foregroundColor = .black
        string.font = .system(size: 16, weight: .bold)
        
        if let range = string.range(of: label) {
            string[range].foregroundColor = .black.opacity(0.8)
            string[range].font = .system(size: 16, weight: .regular)
        }
        
        return string
    }
}

struct QuoteView_Previews: PreviewProvider {
    static var previews: some View {
        QuoteView(item: Quote(anime: "Anime", character: "Character", quote: "Quote"))
    }
}
