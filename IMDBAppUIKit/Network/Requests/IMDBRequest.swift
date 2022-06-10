//
//  IMDBRequest.swift
//  IMDBAppUIKit
//
//  Created by Jackson  on 10/06/2022.
//

import Foundation

enum IMDBRequest: RequestDetails, Request {
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getMostPopular: return .GET
        }
    }
    
    var body: Data? { return nil }
    
    case getMostPopular
    
    
    var path: String {
        switch self {
        case .getMostPopular: return "MostPopularTVs/"
        }
    }
    
    var url: String { URLs.baseURL }
}
