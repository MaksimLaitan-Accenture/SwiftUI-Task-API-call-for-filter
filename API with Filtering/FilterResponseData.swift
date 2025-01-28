//
//  FilterResponseData.swift
//  API with Filtering
//
//  Created by Maksim Laitan on 28/01/2025.
//

import Foundation

struct FilterResponseData: Identifiable, Codable {
    
    let id = UUID() // to make identifiable
    let discountPercentage: Int
    let employerID: Int
    let name: String
    let place: String
    
    private enum CodingKeys: String, CodingKey {
        case discountPercentage = "DiscountPercentage"
        case employerID = "EmployerID"
        case name = "Name"
        case place = "Place"
    }
}
