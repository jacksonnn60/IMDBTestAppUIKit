//
//  HTTPClient.swift
//  IMDBAppUIKit
//
//  Created by Jackson  on 10/06/2022.
//

import Foundation

typealias ResultClosure<T> = (Result<T, Error>) -> ()

protocol IHTTPClient {
    func execute<T: Codable>(_ request: Request, completion: @escaping (Result<T, Error>) -> ())
}

final class HTTPClient: IHTTPClient {
    
    private let urlSession: URLSession
    
    // MARK: - Init
    
    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }
    
    // MARK: - Protocol
    
    func execute<T: Codable>(_ request: Request, completion: @escaping (Result<T, Error>) -> ()) {
        executeRequest(request.request, completion: completion)
    }
}

// MARK: - Private

private extension HTTPClient {
    func executeRequest<T: Codable>(_ request: URLRequest, completion: @escaping ResultClosure<T>) {
        urlSession.dataTask(with: request) { data, response, error in
            do {
                if let error = error { throw error }
                guard let response = response as? HTTPURLResponse else { throw "Invalid response" }
                guard let data = data else { throw "Response data is empty" }
                guard let statusCode = HTTPStatusCode(rawValue: response.statusCode) else {
                    throw "Status code is invalid"
                }

                switch statusCode.responseType {
                case .success:
                    print("✅(\(statusCode.rawValue)), \(request.httpMethod ?? "httpMethod") \(request.url?.path ?? "")")
                    
                    completion(.success(try JSONDecoder().decode(T.self, from: data)))
                default:
                    throw error ?? "❌Error: response is not success && error == nil"
                }
            } catch let error {
                print("❌(\(error)) \(request.url?.path ?? "")")
                
                completion(.failure(error))
            }
        }.resume()
    }
}
