//
//  Constants.swift
//  API with Filtering
//
//  Created by Maksim Laitan on 28/01/2025.
//

import Foundation

struct C {
    
    static let emptyString = ""
    
    struct Filter {
        static let navigationTitle = "Filter Data"
        static let companyFieldPlaceholder = "Enter Company name"
        static let limitFieldPlaceholder = "Enter limit of records (default is 0)"
        static let actionButtonText = "Fetch Data"
        static let progressText = "Fetching Data..."
        static let initialPlaceholder = "Please enter Company name and limit of response records. \nAnd press \"Fetch Data\" button. \n(Default limit is 0, which means all records)"
        static let emptyResultText = "Nothing was found by your filter input. \nCheck input data or try another data."
        static func errorMessage(_ errorMessage: String) -> String {
            "Error: \(errorMessage)"
        }
        static func employerIdText(_ id: Int) -> String {
            "ID: \(id)"
        }
        static func discountPercentageText(_ text: Int) -> String {
            "Discount: \(text)%"
        }
        static func placeText(_ text: String) -> String {
            "Place: \(text)"
        }
    }
    
    struct Network {
        
        static let baseURLString = "https://cba.kooijmans.nl/CBAEmployerservice.svc/rest"
        
        static func getFilterData(company: String, limit: String) -> String {
            C.Network.baseURLString + "/employers?filter=\(company)&maxRows=\(limit)"
        }
        
        struct Error {
            static let invalidURL = "The provided URL is invalid."
            static let invalidResponse = "The server response was invalid."
            static let decodingError = "Failed to decode the response from the server."
            static let unknownError = "An unknown error occurred."
            
            static func httpError(_ text: Int) -> String {
                "HTTP error occurred with status code \(text)."
            }
            
            static func errorSavingData(_ text: any Swift.Error) -> String {
                "Error saving data: \(text)"
            }
        }
        
        
    }
}
