//
//  FilterDataManager.swift
//  API with Filtering
//
//  Created by Maksim Laitan on 28/01/2025.
//

import Foundation

struct FilterDataManager {
    func getFilteredData(for companyName: String, with limitOfRecords: String) async throws -> [FilterResponseData] {
        let networkManager = NetworkManager(httpClient: HTTPClientManager.shared.getHTTPClient())
        
        let data = try await networkManager.fetchData(from: C.Network.getFilterData(company: companyName, limit: limitOfRecords), as: [FilterResponseData].self)
        return data
    }
}
