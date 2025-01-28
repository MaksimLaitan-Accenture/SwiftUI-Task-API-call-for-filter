//
//  RequestItem.swift
//  API with Filtering
//
//  Created by Maksim Laitan on 28/01/2025.
//

import Foundation
import SwiftData

@Model
final class RequestItem {
    
    @Attribute(.unique) var requestKey: [String: String]
    var responseData: [FilterResponseData]
    var timestamp: Date
    
    init(requestKey: [String : String], responseData: [FilterResponseData], timestamp: Date) {
        self.requestKey = requestKey
        self.responseData = responseData
        self.timestamp = timestamp
    }
    
}
