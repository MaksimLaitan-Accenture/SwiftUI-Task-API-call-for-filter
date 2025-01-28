//
//  FilterViewModel.swift
//  API with Filtering
//
//  Created by Maksim Laitan on 28/01/2025.
//

import Foundation
import SwiftData

@Observable
final class FilterViewModel {
    
    var responseData: [FilterResponseData] = [] // Array to hold the response result
    var isLoading: Bool = false  // Loading state
    var errorMessage: String? = nil // Error state
    var isFirstRequest: Bool = true // Request status
    
    // State variables for the two fields
    var companyName: String = ""
    var limitOfrecords: String = ""
    
    private let cachedDataManager = CachedDataManager()
    
    // Async function to fetch response
    @MainActor
    func fetchData(context: ModelContext) async {
        isLoading = true
        isFirstRequest = false
        
        if let cachedData = cachedDataManager.fetchCachedData(requestKey: [companyName : limitOfrecords], context: context) {
            responseData = cachedData.responseData
            isLoading = false
            return
        }
        
        guard let url = URL(string: "https://cba.kooijmans.nl/CBAEmployerservice.svc/rest/employers?filter=\(companyName)&maxRows=\(limitOfrecords)") else {
            errorMessage = "Invalid URL."
            isLoading = false
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedData = try JSONDecoder().decode([FilterResponseData].self, from: data)
            Task {
                responseData = decodedData
                cachedDataManager.saveData(requestKey: [companyName : limitOfrecords], responseData: decodedData, context: context)
                isLoading = false
            }
        } catch {
            Task {
                errorMessage = "Failed to fetch data: \(error.localizedDescription)"
                isLoading = false
            }
        }
    }
}
