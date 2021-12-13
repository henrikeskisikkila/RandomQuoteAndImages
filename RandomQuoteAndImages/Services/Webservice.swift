//
//  Webservice.swift
//  RandomQuoteAndImages
//
//  Created by Henri on 12.12.2021.
//

import Foundation
import UIKit

enum NetworkError: Error {
    case badURL
    case invalidImageId(Int)
    case decodingError
}

class Webservice {
    
    func getRandomImages(ids: [Int]) async throws -> [RandomImage] {
        var randomImages: [RandomImage] = []
        
        try await withThrowingTaskGroup(of: (Int, RandomImage).self) { group in
            for id in ids {
                group.addTask {
                    return (id, try await self.getRandomImage(id: id))
                }
            }
            
            for try await(_, randomImage) in group {
                print(randomImage)
                randomImages.append(randomImage)
            }
        }
        
        return []
    }
    
    func getRandomImage(id: Int) async throws -> RandomImage {

        let url = try randomImageUrl()
        let quoteURL = try randomQuoteURL()
        
        async let (imageData, _) = URLSession.shared.data(from: url)
        async let (randomQuoteData, _) = URLSession.shared.data(from: quoteURL)
        
        guard let quote = try? JSONDecoder().decode(Quote.self, from: try await randomQuoteData) else {
            throw NetworkError.decodingError
        }
        
        return RandomImage(image: try await imageData, quote: quote)
    }
    
    func randomImageUrl() throws -> URL {
        guard let url = Constants.Urls.getRandomImageUrl() else {
            throw NetworkError.badURL
        }
        return url
    }
    
    func randomQuoteURL() throws -> URL {
        guard let randomQuoteUrl = Constants.Urls.randomQuoteUrl else {
            throw NetworkError.badURL
        }
        return randomQuoteUrl
    }
}
