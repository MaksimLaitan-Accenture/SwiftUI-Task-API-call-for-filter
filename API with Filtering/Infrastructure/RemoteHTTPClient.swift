//
//  RemoteHTTPClient.swift
//  API with Filtering
//
//  Created by Maksim Laitan on 28/01/2025.
//

import Foundation

final class RemoteHTTPClient: HTTPClient {
    func get(from urlString: String) async throws -> Swift.Result<(Data, HTTPURLResponse), Error> {
        
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.httpError(statusCode: httpResponse.statusCode)
        }
        
        return .success((data, httpResponse))
    }
    
}
