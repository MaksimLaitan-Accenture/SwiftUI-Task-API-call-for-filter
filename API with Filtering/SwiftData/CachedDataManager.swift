//
//  CachedDataManager.swift
//  API with Filtering
//
//  Created by Maksim Laitan on 28/01/2025.
//

import Foundation
import SwiftData

final class CachedDataManager {
    
    func fetchCachedData(requestKey: [String: String], context: ModelContext) -> RequestItem? {
        let oneWeekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date())!

        let result = try? context.fetch(
            FetchDescriptor<RequestItem>(
                predicate: #Predicate { $0.requestKey == requestKey && $0.timestamp >= oneWeekAgo }
            )
        )
        return result?.first
    }
    
    func saveData(requestKey: [String: String], responseData: [FilterResponseData], context: ModelContext) {
        let apiData = RequestItem(requestKey: requestKey, responseData: responseData, timestamp: Date())
        context.insert(apiData)

        do {
            try context.save()
        } catch {
            print(C.Network.Error.errorSavingData(error))
        }
    }
}
