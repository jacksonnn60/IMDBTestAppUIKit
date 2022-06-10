//
//  IMDBService.swift
//  IMDBAppUIKit
//
//  Created by Jackson  on 10/06/2022.
//

import Foundation

protocol IIMDBService: AnyObject {
    func fetchMostPopularTVs(_ completion: @escaping ResultClosure<[IMDBItem]>)
}

final class IMDBService: IIMDBService {
    
    // MARK: - Properties
    
    private let httpClient: IHTTPClient
    
    // MARK: - Init
    
    init(httpClient: IHTTPClient) {
        self.httpClient = httpClient
    }
    
    // MARK: - Main Actions
    
    func fetchMostPopularTVs(_ completion: @escaping (Result<[IMDBItem], Error>) -> ()) {
        httpClient.execute(IMDBRequest.getMostPopular) { (result: (Result<IMDBMostPopularResponseData, Error>)) in
            
            switch result {
            case .success(let response):
                response.errorMessage.isEmpty ? completion(.success(response.items)) : completion(.failure(response.errorMessage))
            case .failure(let error): completion(.failure(error))
            }
        }
    }
}
