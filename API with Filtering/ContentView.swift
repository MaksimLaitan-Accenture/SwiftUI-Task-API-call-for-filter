//
//  ContentView.swift
//  API with Filtering
//
//  Created by Maksim Laitan on 28/01/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
//    @Environment(\.modelContext) private var modelContext
//    @Query private var items: [Item]

    @State private var responseData: [FilterResponseData] = [] // Array to hold the response result
    @State private var isLoading: Bool = true  // Loading state
    @State private var errorMessage: String? = nil // Error state
    
    var body: some View {
        NavigationView {
            ScrollView {
                if isLoading {
                    ProgressView("Fetching Data...")
                        .padding()
                } else if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                } else {
                    ForEach(responseData) { data in
                        GroupBox(label: Text("Response Data")) {
                            Text(data.name)
                                .padding()
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Filter Data")
        }
        .task {
            await fetchData()
        }
    }
    
    // Async function to fetch response
    private func fetchData() async {
        guard let url = URL(string: "https://cba.kooijmans.nl/CBAEmployerservice.svc/rest/employers?filter=Achmea&maxRows=100") else {
            errorMessage = "Invalid URL."
            isLoading = false
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedData = try JSONDecoder().decode([FilterResponseData].self, from: data)
            DispatchQueue.main.async {
                responseData = decodedData
                isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                errorMessage = "Failed to fetch data: \(error.localizedDescription)"
                isLoading = false
            }
        }
    }
}

#Preview {
    ContentView()
//        .modelContainer(for: Item.self, inMemory: true)
}
