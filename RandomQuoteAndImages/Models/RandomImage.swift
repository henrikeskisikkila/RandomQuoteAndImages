//
//  RandomImage.swift
//  RandomQuoteAndImages
//
//  Created by Henri on 12.12.2021.
//

import Foundation


struct RandomImage: Decodable {
    let image: Data
    let quote: Quote
}

struct Quote: Decodable {
    let content: String
    let author: String
}

