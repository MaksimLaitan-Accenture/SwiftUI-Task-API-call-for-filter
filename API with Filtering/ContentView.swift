//
//  ContentView.swift
//  API with Filtering
//
//  Created by Maksim Laitan on 28/01/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [RequestItem]
    
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
            .navigationTitle(C.Filter.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    @ViewBuilder
    private func filterFieldsView() -> some View {
        TextField(C.Filter.companyFieldPlaceholder, text: $viewModel.companyName)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal)
        
        TextField(C.Filter.limitFieldPlaceholder, text: $viewModel.limitOfrecords)
            .keyboardType(.numberPad)
            .onChange(of: viewModel.limitOfrecords) { _, newValue in
                viewModel.limitOfrecords = newValue.filter { $0.isNumber }
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal)
        
        Button(action: {
            Task {
                await viewModel.fetchData(context: modelContext)
            }
        }) {
            Text(C.Filter.actionButtonText)
        }
        .buttonStyle(.borderedProminent)
        .padding(.top, 2)
        .disabled(viewModel.isLoading)
    }
    
    @ViewBuilder
    private func loadingView() -> some View {
        ProgressView(C.Filter.progressText)
            .padding()
    }
    
    @ViewBuilder
    private func initialPlaceholder() -> some View {
        Text(C.Filter.initialPlaceholder)
            .font(.callout)
            .padding(40)
            .multilineTextAlignment(.center)
    }
    
    @ViewBuilder
    private func errorMessageView(message errorMessage: String) -> some View {
        Text(C.Filter.errorMessage(errorMessage))
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
                                Text(C.Filter.employerIdText(data.employerID))
                                Text(C.Filter.discountPercentageText(data.discountPercentage))
                                Text(C.Filter.placeText(data.place))
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
        Text(C.Filter.emptyResultText)
            .font(.callout)
            .padding(40)
            .multilineTextAlignment(.center)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: RequestItem.self, inMemory: true)
}
