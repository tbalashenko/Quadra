//
//  ChartLinesView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 15/05/2024.
//

import SwiftUI
import Charts

struct ChartLinesView: View {
    @ObservedObject var viewModel: StatViewModel
    @Binding var selectedPeriod: Period
    
    var body: some View {
        Chart {
            ForEach(viewModel.statData) { data in
                if viewModel.showTotalNumber {
                    if viewModel.showTotalNumber {
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
                }
                
                if viewModel.showAddedCards {
                    LineMark(
                        x: .value("Date", data.date, unit: .day),
                        y: .value(ChartLine.added.rawValue, data.addedItemsCounter),
                        series: .value(ChartLine.added.rawValue, "B")
                    )
                    .foregroundStyle(ChartLine.added.color)
                    .interpolationMethod(.monotone)
                }
                
                if viewModel.showRepeatedCards {
                    LineMark(
                        x: .value("Date", data.date, unit: .day),
                        y: .value(ChartLine.repeated.rawValue, data.repeatedItemsCounter),
                        series: .value(ChartLine.repeated.rawValue, "C")
                    )
                    .foregroundStyle(ChartLine.repeated.color)
                    .interpolationMethod(.monotone)
                }
                
                if viewModel.showDeletedCards {
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
        .chartForegroundStyleScale([
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
    }
}

#Preview {
    ChartLinesView(viewModel: StatViewModel(), selectedPeriod: .constant(Period.last2Weeks))
}
