//
//  StatView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 17/04/2024.
//

import SwiftUI
import Charts

struct StatView: View {
    @FetchRequest(
        sortDescriptors: [SortDescriptor(\.date, order: .forward)],
        predicate: NSPredicate(value: false),
        animation: .default)
    private var statData: FetchedResults<StatData>
#if DEBUG
    @FetchRequest(sortDescriptors: []) var archiveTags: FetchedResults<ItemArchiveTag>
    @FetchRequest(sortDescriptors: []) var items: FetchedResults<Item>
#endif
    @EnvironmentObject private var dataController: DataController
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var selectedPeriod = Period.lastWeek
    @State private var showTotalNumber = false
    @State private var showAddedCards = true
    @State private var showDeletedCards = true
    @State private var showRepeatedCards = true
    
    private var toggleBindings: [Binding<Bool>] {
        [
            $showTotalNumber,
            $showAddedCards,
            $showDeletedCards,
            $showRepeatedCards
        ]
    }
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                List {
                    chart(geometry: geometry)
                        .onChange(of: selectedPeriod) {
                            updatePredicate()
                        }
                        .onAppear {
                            updatePredicate()
                        }
                    periodPicker()
                    toggles()
                }
                .listStyle(.plain)
                .navigationTitle("Chart")
                .scrollContentBackground(.hidden)
                .background(Color.element)
#if DEBUG
                .toolbar {
                    ToolbarItem {
                        Button(action: {
                            addRandomData()
                            updatePredicate()
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                }
#endif
            }
        }
    }
    
    private func chart(geometry: GeometryProxy) -> some View {
        Chart {
            ForEach(statData) { data in
                if showTotalNumber {
                    LineMark(
                        x: .value("Date", data.date, unit: .day),
                        y: .value(ChartLine.totalNumber.rawValue, data.totalNumberOfCards),
                        series: .value(ChartLine.totalNumber.rawValue, "A")
                    )
                    .foregroundStyle(ChartLine.totalNumber.color)
                    .interpolationMethod(.monotone)
                    
                    AreaMark(
                        x: .value("Date", data.date, unit: .day),
                        y: .value(ChartLine.totalNumber.rawValue, data.totalNumberOfCards),
                        series: .value(ChartLine.totalNumber.rawValue, "A")
                    )
                    .foregroundStyle(ChartLine.totalNumber.gradient)
                    .interpolationMethod(.monotone)
                }
                
                if showAddedCards {
                    LineMark(
                        x: .value("Date", data.date, unit: .day),
                        y: .value(ChartLine.added.rawValue, data.addedItemsCounter),
                        series: .value(ChartLine.added.rawValue, "B")
                    )
                    .foregroundStyle(ChartLine.added.color)
                    .interpolationMethod(.monotone)
                }
                
                if showRepeatedCards {
                    LineMark(
                        x: .value("Date", data.date, unit: .day),
                        y: .value(ChartLine.repeated.rawValue, data.repeatedItemsCounter),
                        series: .value(ChartLine.repeated.rawValue, "C")
                    )
                    .foregroundStyle(ChartLine.repeated.color)
                    .interpolationMethod(.monotone)
                }
                
                if showDeletedCards {
                    LineMark(
                        x: .value("Date", data.date, unit: .day),
                        y: .value(ChartLine.deleted.rawValue, data.deletedItemsCounter),
                        series: .value(ChartLine.deleted.rawValue, "D")
                    )
                    .lineStyle(StrokeStyle(dash: [5,7]))
                    .foregroundStyle(ChartLine.deleted.color)
                    .interpolationMethod(.monotone)
                }
            }
        }
        .chartForegroundStyleScale( [
            ChartLine.totalNumber.rawValue: ChartLine.totalNumber.color,
            ChartLine.added.rawValue: ChartLine.added.color,
            ChartLine.repeated.rawValue: ChartLine.repeated.color,
            ChartLine.deleted.rawValue: ChartLine.deleted.color
        ])
        .chartXVisibleDomain(length: selectedPeriod.chartXVisibleDomainLength)
        .chartScrollableAxes(.horizontal)
        .chartLegend(position: .bottom)
        .chartYAxis() { AxisMarks(position: .leading) }
        .chartXAxis {
            AxisMarks(values: selectedPeriod.axisMarksValues) { _ in
                AxisGridLine()
                AxisTick()
                AxisValueLabel(format: .dateTime.month().day(), centered: true)
            }
        }
        .frame(height: geometry.size.width)
        .styleListSection()
    }
    
    private func periodPicker() -> some View {
        Picker("Period", selection: $selectedPeriod) {
            ForEach(Period.allCases) { period in
                Text(period.rawValue).tag(period)
            }
        }
        .pickerStyle(.menu)
        .styleListSection()
    }
    
    private func toggles() -> some View {
        ForEach(ChartLine.allCases.indices, id: \.self) { index in
            Toggle(ChartLine.allCases[index].rawValue, isOn: toggleBindings[index])
                .tint(ChartLine.allCases[index].color.opacity(0.3))
        }
        .styleListSection()
    }
    
    private func updatePredicate() {
        let predicate = NSPredicate(format: "date >= %@ AND date <= %@", selectedPeriod.fromDate as NSDate, Date() as NSDate)
        
        statData.nsPredicate = predicate
    }
    
    
#if DEBUG
    private func addRandomData() {
        let fromDate = Calendar.current.date(byAdding: .year, value: -1, to: Date())
        
        for index in 0...365 {
            let date = Calendar.current.date(byAdding: .day, value: index, to: fromDate!) ?? Date()
            let item = Item(context: viewContext)
            let string = "Test" + String(Int.random(in: 1...365))
            item.phraseToRemember = NSAttributedString(string: string)
            item.status = Status.input
            item.id = UUID()
            item.additionTime = date
            if let tag = archiveTags.first(where: { $0.title == date.prepareTag() }) {
                tag.addToItems(item)
            } else {
                let tag = ItemArchiveTag(context: viewContext)
                tag.id = UUID()
                tag.color = ItemArchiveTag.getColor(for: date)
                tag.title = date.prepareTag()
                tag.items = NSSet(array: [item])
            }
            
            try? viewContext.save()
            
            let currentDate = date.formattedForStats()
            if let statData = statData.first(where: { $0.date == currentDate }) {
                statData.repeatedItemsCounter = Int.random(in: 1...5)
                let addedItems = Int.random(in: 1...3)
                statData.addedItemsCounter = addedItems
                let delItems = Int.random(in: 0...1)
                statData.deletedItemsCounter = delItems
                statData.totalNumberOfCards = items.count
                
                try? viewContext.save()
            } else {
                let statData = StatData(context: viewContext)
                statData.date = currentDate ?? Date()
                statData.repeatedItemsCounter = Int.random(in: 1...5)
                let addedItems = Int.random(in: 1...3)
                statData.addedItemsCounter = addedItems
                let delItems = Int.random(in: 0...1)
                statData.deletedItemsCounter = delItems
                statData.totalNumberOfCards = items.count
                
                try? viewContext.save()
            }
            updatePredicate()
        }
    }
#endif
}

#Preview {
    StatView()
}
