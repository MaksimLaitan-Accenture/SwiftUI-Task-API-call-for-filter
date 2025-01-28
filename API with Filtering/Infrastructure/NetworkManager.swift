//
//  NetworkManager.swift
//  API with Filtering
//
//  Created by Maksim Laitan on 28/01/2025.
//

import Foundation

final class NetworkManager {
    private let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func fetchData<T: Decodable>(from urlString: String, as type: T.Type) async throws -> T {
        let result = try await self.httpClient.get(from: urlString)
        switch result {
        case .success(let (data, _)):
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                return decodedData
            } catch {
                throw APIError.decodingError
            }
        case .failure(let error):
            throw error
        }
    }
}
