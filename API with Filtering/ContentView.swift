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
                    filterFieldsView()
                }
                .padding(.bottom) // Add vertical padding for spacing
                
                Divider()
                
                if viewModel.isFirstRequest {
                    initialPlaceholder()
                } else if viewModel.isLoading {
                    loadingView()
                } else if let errorMessage = viewModel.errorMessage {
                    errorMessageView(message: errorMessage)
                } else if !viewModel.responseData.isEmpty {
                    dataView()
                } else {
                    emptyrResultView()
                }
                
                Spacer()
            }
            .navigationTitle("Filter Data")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    @ViewBuilder
    private func filterFieldsView() -> some View {
        TextField("Enter Company name", text: $viewModel.companyName)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal)
        
        TextField("Enter limit of records (default is 0)", text: $viewModel.limitOfrecords)
            .keyboardType(.numberPad)
            .onChange(of: viewModel.limitOfrecords) { _, newValue in
                viewModel.limitOfrecords = newValue.filter { $0.isNumber }
            }
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
    
    @ViewBuilder
    private func loadingView() -> some View {
        ProgressView("Fetching Data...")
            .padding()
    }
    
    @ViewBuilder
    private func initialPlaceholder() -> some View {
        Text("Please enter Company name and limit of response records. \nAnd press \"Fetch Data\" button. \n(Default limit is 0, which means all records)")
            .font(.callout)
            .padding(40)
            .multilineTextAlignment(.center)
    }
    
    @ViewBuilder
    private func errorMessageView(message errorMessage: String) -> some View {
        Text("Error: \(errorMessage)")
            .foregroundColor(.red)
            .padding()
    }
    
    @ViewBuilder
    private func dataView() -> some View {
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
    
    @ViewBuilder
    private func emptyrResultView() -> some View {
        Text("Nothing was found by your filter input. \nCheck input data or try another data.")
            .font(.callout)
            .padding(40)
            .multilineTextAlignment(.center)
    }
}

#Preview {
    ContentView()
//        .modelContainer(for: Item.self, inMemory: true)
}
