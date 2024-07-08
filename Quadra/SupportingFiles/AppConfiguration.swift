//
//  AppConfiguration.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 04/07/2024.
//

import Foundation

class AppConfiguration {
    static func configure() {
        NotificationsService.shared.scheduleNotifications()
    }
}
