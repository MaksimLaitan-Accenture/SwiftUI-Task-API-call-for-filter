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
            return "The provided URL is invalid."
        case .invalidResponse:
            return "The server response was invalid."
        case .httpError(let statusCode):
            return "HTTP error occurred with status code \(statusCode)."
        case .decodingError:
            return "Failed to decode the response from the server."
        case .unknownError:
            return "An unknown error occurred."
        }
    }
}
