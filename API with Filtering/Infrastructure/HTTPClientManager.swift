//
//  HTTPClientManager.swift
//  API with Filtering
//
//  Created by Maksim Laitan on 28/01/2025.
//

import Foundation

struct HTTPClientManager {
    static let shared = HTTPClientManager()
    
    private init() {}
    
    func getHTTPClient() -> HTTPClient {
        RemoteHTTPClient()
        // add mock option
    }
}
