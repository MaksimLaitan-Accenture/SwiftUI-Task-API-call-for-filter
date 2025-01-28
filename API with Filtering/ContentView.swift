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
    
    @State private var viewModel = FilterViewModel()
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                VStack(spacing: 10) {
                    TextField("Enter Company name", text: $viewModel.companyName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    TextField("Enter limit of records", value: $viewModel.limitOfrecords, formatter: formatter)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    Button(action: {
                        Task {
                            await viewModel.fetchData()
                        }
                    }) {
                        Text("Fetch Data")
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.top, 2)
                    .disabled(viewModel.isLoading)
                }
                .padding(.bottom) // Add vertical padding for spacing
                
                Divider()
                
                if (!viewModel.isLoading && viewModel.responseData.isEmpty && viewModel.companyName.isEmpty && viewModel.limitOfrecords.isEmpty) {
                    Text("Please enter Company name and limit of response records")
                        .font(.callout)
                        .padding(40)
                        .multilineTextAlignment(.center)
                } else if viewModel.isLoading {
                    ProgressView("Fetching Data...")
                        .padding()
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                } else {
                
                ScrollView {
                        ForEach(viewModel.responseData) { data in
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
                
                Spacer()
            }
            .navigationTitle("Filter Data")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    

}

#Preview {
    ContentView()
//        .modelContainer(for: Item.self, inMemory: true)
}
