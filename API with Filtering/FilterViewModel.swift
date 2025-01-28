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
    var companyName: String = C.emptyString
    var limitOfrecords: String = C.emptyString
    
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
        
        do {
            responseData = try await FilterDataManager().getFilteredData(for: companyName, with: limitOfrecords)
            
            cachedDataManager.saveData(requestKey: [companyName : limitOfrecords], responseData: responseData, context: context)
            isLoading = false
        }
        catch let error as APIError {
            errorMessage = error.errorDescription
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
}
