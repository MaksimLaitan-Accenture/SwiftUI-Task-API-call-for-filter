//
//  APIError.swift
//  API with Filtering
//
//  Created by Maksim Laitan on 28/01/2025.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingError
    case unknownError
    
    // Provide a localized description for each error case
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            C.Network.Error.invalidURL
        case .invalidResponse:
            C.Network.Error.invalidResponse
        case .httpError(let statusCode):
            C.Network.Error.httpError(statusCode)
        case .decodingError:
            C.Network.Error.decodingError
        case .unknownError:
            C.Network.Error.unknownError
        }
    }
}
