//
//  IMDBMostPopularResponseData.swift
//  IMDBAppUIKit
//
//  Created by Jackson  on 10/06/2022.
//

import Foundation

struct IMDBMostPopularResponseData: Codable {
    let items: [IMDBItem]
    let errorMessage: String
}

struct IMDBItem: Codable {
    let id: String
    let rank: String
    let rankUpDown: String
    let title: String
    let fullTitle: String
    let year: String
    let image: String
    let crew: String
    let imDBRating: String
    let imDBRatingCount: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case rank = "rank"
        case rankUpDown = "rankUpDown"
        case title = "title"
        case fullTitle = "fullTitle"
        case year = "year"
        case image = "image"
        case crew = "crew"
        case imDBRating = "imDbRating"
        case imDBRatingCount = "imDbRatingCount"
    }
}
