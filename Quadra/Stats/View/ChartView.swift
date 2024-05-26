//
//  ChartView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 15/05/2024.
//

import SwiftUI

struct ChartView: View {
    @Binding var selectedPeriod: Period
    var toggleBindings: [Binding<Bool>]
    @ObservedObject var viewModel: StatViewModel
    
    var body: some View {
        GeometryReader { geometry in
            List {
                ChartLinesView(
                    viewModel: viewModel,
                    selectedPeriod: $selectedPeriod)
                    .frame(height: geometry.size.width)
                    .onChange(of: selectedPeriod) { viewModel.fetchStatData(fromDate: selectedPeriod.fromDate) }
                    .onAppear { viewModel.fetchStatData(fromDate: selectedPeriod.fromDate) }
                PeriodPickerView(selectedPeriod: $selectedPeriod)
                ChartLineToggleView(toggleBindings: toggleBindings)
            }
            .listStyle(.plain)
            .navigationTitle("Statistics")
            .scrollContentBackground(.hidden)
            .background(Color.element)
#if DEBUG
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        viewModel.addRandomData()
                        viewModel.fetchStatData(fromDate: selectedPeriod.fromDate)
                    }) {
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }
#endif
        }
    }
}

#Preview {
    let toggle1 = Binding<Bool>(get: { false }, set: { _ in })
    let toggle2 = Binding<Bool>(get: { true }, set: { _ in })
    let toggle3 = Binding<Bool>(get: { true }, set: { _ in })
    let toggle4 = Binding<Bool>(get: { true }, set: { _ in })
    
    let toggleBindings: [Binding<Bool>] = [toggle1, toggle2, toggle3, toggle4]
    
    return ChartView(
        selectedPeriod: .constant(.last2Weeks),
        toggleBindings: toggleBindings,
        viewModel: StatViewModel())
}
