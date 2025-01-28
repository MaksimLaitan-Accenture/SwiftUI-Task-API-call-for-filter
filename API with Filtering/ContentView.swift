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
    @State private var isLoading: Bool = false  // Loading state
    @State private var errorMessage: String? = nil // Error state
    
    // State variables for the two fields
    @State private var companyName: String = ""
    @State private var limitOfrecords: String = ""
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                VStack(spacing: 10) {
                    TextField("Enter Company name", text: $companyName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    TextField("Enter limit of records", value: $limitOfrecords, formatter: formatter)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    Button(action: {
                        Task {
                            await fetchData()
                        }
                    }) {
                        Text("Fetch Data")
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.top, 2)
                    .disabled(isLoading)
                }
                .padding(.vertical) // Add vertical padding for spacing
                
                Divider()
                
                ScrollView {
                    if (!isLoading && responseData.isEmpty && companyName.isEmpty && limitOfrecords.isEmpty) {
                        Text("Please enter Company name and limit of response records")
                            .font(.callout)
                            .padding(40)
                            .multilineTextAlignment(.center)
                    }
                    
                    if isLoading {
                        ProgressView("Fetching Data...")
                            .padding()
                    } else if let errorMessage = errorMessage {
                        Text("Error: \(errorMessage)")
                            .foregroundColor(.red)
                            .padding()
                    } else {
                        ForEach(responseData) { data in
                            GroupBox {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("ID: \(data.employerID)")
                                        Text("Discount: \(data.discountPercentage)%")
                                        Text("Place: \(data.place)")
                                    }
                                    .padding(.top, 3)
                                    Spacer()
                                }
                            } label: {
                                Text(data.name)
                            }
                            .padding(.bottom, 3)
                            .padding(.horizontal)
                        }
                    }
                }
                .navigationTitle("Filter Data")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
    
    // Async function to fetch response
    private func fetchData() async {
        isLoading = true
        guard let url = URL(string: "https://cba.kooijmans.nl/CBAEmployerservice.svc/rest/employers?filter=Ac&maxRows=100") else {
            errorMessage = "Invalid URL."
            isLoading = false
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedData = try JSONDecoder().decode([FilterResponseData].self, from: data)
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
//            DispatchQueue.main.async {
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
