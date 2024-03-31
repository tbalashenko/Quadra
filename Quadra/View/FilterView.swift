//
//  FilterView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 27/03/2024.
//

import SwiftUI

struct FilterView: View {
    @FetchRequest(sortDescriptors: [])  var sources: FetchedResults<Source>
    @EnvironmentObject var dataManager: CardManager
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) var dismiss
    @Binding var selectedStatuses: [Status]
    @Binding var fromDate: Date
    @Binding var toDate: Date
    @Binding var selectedSources: [Source]
    @Binding var minDate: Date
    @State private var totalHeight = CGFloat.infinity
    @State private var modifiedSources: [Source] = []
    @State var filteredSources = [Source]()
    
    var body: some View {
        GeometryReader { geometry in
            List {
                GroupBox("Status") {
                    HStack(spacing: 8) {
                        ForEach(Status.allStatuses, id: \.self) { status in
                            TagView(text: status.title,
                                    backgroundColor: selectedStatuses.contains(status) ? Color(hex: status.color) : Color.offWhiteGray) {
                                toggleStatus(status)
                            }
                        }
                    }
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.element)
                
                GroupBox("Creation Date") {
                    DatePicker("From",
                               selection: $fromDate,
                               displayedComponents: [.date])
                    .datePickerStyle(.compact)
                    DatePicker("To", selection: $toDate, displayedComponents: [.date])
                        .datePickerStyle(.compact)
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.element)
                
                if !sources.isEmpty {
                    GroupBox("Sources") {
                        TagCloudView(items: selectedSources,
                                     geometry: geometry,
                                     totalHeight: $totalHeight,
                                     action: { selectedSources.remove(at: $0)
                        })
                        
                        TagCloudView(items: filteredSources,
                                     geometry: geometry,
                                     totalHeight: $totalHeight,
                                     inactiveColor: Color.offWhiteGray,
                                     action: { selectedSources.append(filteredSources[$0]) })
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.element)
                    .frame(width: geometry.size.width * 0.85)
                }
            }
            .listStyle(.plain)
            .background(Color.element)
            .onAppear {
                setFilteredSources()
            }
            .onChange(of: selectedSources) { oldValue, newValue in
                setFilteredSources()
            }
            .toolbar {
                ToolbarItem {
                    Button {
                        selectedSources = []
                        selectedStatuses = Status.allStatuses
                        fromDate = minDate
                        toDate = Date()
                    } label: {
                        Text("Reset")
                    }
                }
            }
        }
    }
    
    func toggleStatus(_ status: Status) {
        if selectedStatuses.contains(status) {
            selectedStatuses.removeAll { $0 == status }
        } else {
            selectedStatuses.append(status)
        }
    }
    
    func setFilteredSources() {
        if !selectedSources.isEmpty {
            filteredSources = sources.filter { source in
                !selectedSources.contains(where: { $0.id == source.id }) }
        } else {
            filteredSources = Array(sources)
        }
    }
}

//#Preview {
//    FilterView(selectedStatuses: .constant(Status.allStatuses),
//               fromDate: .constant(Date()),
//               toDate: .constant(Date()))
//}
