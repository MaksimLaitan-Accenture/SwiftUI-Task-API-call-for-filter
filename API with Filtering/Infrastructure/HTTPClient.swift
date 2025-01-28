//
//  HTTPClient.swift
//  API with Filtering
//
//  Created by Maksim Laitan on 28/01/2025.
//

import Foundation

protocol HTTPClient {
    
    func get(from urlString: String) async throws -> Swift.Result<(Data, HTTPURLResponse), Error>
}
