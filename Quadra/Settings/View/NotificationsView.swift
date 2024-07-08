//
//  NotificationsView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 05/07/2024.
//

import SwiftUI

struct NotificationsView: View {
    @ObservedObject var viewModel: SettingsViewModel
    
    var body: some View {
        Toggle(TextConstants.notifications, isOn: $viewModel.sendNotifications)
        if viewModel.sendNotifications {
                DatePicker(
                    "",
                    selection: $viewModel.reminderTime,
                    displayedComponents: .hourAndMinute
                )
                .datePickerStyle(.wheel)
            
        }
        Text(TextConstants.dontMissOut)
            .foregroundColor(.secondary)
            .font(.footnote)
    }
}

#Preview {
    NotificationsView(viewModel: SettingsViewModel())
}
