//
//  SettingsViewModel.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 15/05/2024.
//

import Foundation
import Combine

final class SettingsViewModel: ObservableObject {
    @Published var selectedVoice: Voice = SettingsService.voice
    @Published var selectedRatio: AspectRatio = SettingsService.aspectRatio
    @Published var selectedImageScale: ImageScale = SettingsService.imageScale
    @Published var showConfetti: Bool = SettingsService.showConfetti
    @Published var sendNotifications: Bool = false
    @Published var highlighterPalette: HighlighterPalette = SettingsService.highliterPalette
    @Published var showProgress: Bool = SettingsService.showProgress
    @Published var reminderTime: Date = SettingsService.reminderTime
    
    private var needSetupNotifications: Bool { SettingsService.reminderTime != reminderTime  }
    private var cancellables = Set<AnyCancellable>()

    init() {
        checkNotificationPermission()
        observeNotificationsSwitch()
    }

    func save() {
        SettingsService.save(
            voice: selectedVoice,
            aspectRatio: selectedRatio,
            imageScale: selectedImageScale,
            showConfetti: showConfetti,
            highliterPalette: highlighterPalette,
            showProgress: showProgress,
            sendNotifications: sendNotifications
        )
        
        if needSetupNotifications {
            NotificationsService.shared.scheduleNotifications(time: reminderTime)
        }
    }
    
    func checkNotificationPermission() {
        NotificationsService.shared.canSendNotifications { [weak self] canSend in
            DispatchQueue.main.async {
                self?.sendNotifications = canSend
            }
        }
    }
    
    private func observeNotificationsSwitch() {
        $sendNotifications
            .sink { [weak self] isOn in
                if isOn {
                    NotificationsService.shared.requestNotificationPermission { isEnabled, _ in
                        self?.sendNotifications = isEnabled
                    }
                } else {
                    NotificationsService.shared.removeNotifications(removeTime: true)
                }
            }
            .store(in: &cancellables)
    }
}
