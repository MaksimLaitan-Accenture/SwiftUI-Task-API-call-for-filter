//
//  FilterViewModel.swift
//  API with Filtering
//
//  Created by Maksim Laitan on 28/01/2025.
//

import Foundation

@Observable
final class FilterViewModel {
    var responseData: [FilterResponseData] = [] // Array to hold the response result
    var isLoading: Bool = false  // Loading state
    var errorMessage: String? = nil // Error state
    
    // State variables for the two fields
    var companyName: String = ""
    var limitOfrecords: String = ""
    
    // Async function to fetch response
    func fetchData() async {
        isLoading = true
        guard let url = URL(string: "https://cba.kooijmans.nl/CBAEmployerservice.svc/rest/employers?filter=Ac&maxRows=100") else {
            errorMessage = "Invalid URL."
            isLoading = false
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedData = try JSONDecoder().decode([FilterResponseData].self, from: data)
            Task {
                responseData = decodedData
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
