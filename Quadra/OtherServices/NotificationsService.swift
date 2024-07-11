//
//  NotificationsService.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 28/06/2024.
//

import UserNotifications
import UIKit

final class NotificationsService {
    static let shared = NotificationsService()
    
    private init() { }
    
    func getStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            completion(settings.authorizationStatus)
        }
    }
    
    func requestNotificationPermission(completion: @escaping (Bool, String?) -> Void) {
        getStatus { status in
            switch status {
                case .notDetermined:
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
                        DispatchQueue.main.async {
                            if granted {
                                completion(true, nil)
                            } else {
                                completion(false, error?.localizedDescription)
                            }
                        }
                    }
                case .denied:
                    DispatchQueue.main.async {
                        self.showSettingsAlert()
                        completion(false, TextConstants.notificationsDenid)
                    }
                case .authorized, .provisional, .ephemeral:
                    DispatchQueue.main.async {
                        completion(true, nil)
                    }
                @unknown default:
                    fatalError(TextConstants.unknownAuthorizationStatus)
            }
        }
    }
    
    func canSendNotifications(completion: @escaping (Bool) -> Void) {
        getStatus { status in
            switch status {
            case .denied, .notDetermined:
                completion(false)
            case .authorized, .provisional, .ephemeral:
                let canSend = UserDefaultsManager.boolForKey(UserDefaultsKeys.sendNotifications) ?? false
                completion(canSend)
            @unknown default:
                completion(false)
            }
        }
    }
    
    func scheduleNotifications(time: Date? = nil) {
        guard let time = time ?? UserDefaultsManager.dateForKey(UserDefaultsKeys.reminderTime) else { return }
        
        removeNotifications()
        
        getStatus { status in
            guard status == .authorized || status == .provisional else { return }
            
            let content = UNMutableNotificationContent()
            content.title = TextConstants.notificationTitle
            content.body = TextConstants.notificationTexts.randomElement() ?? TextConstants.notificationText
            content.sound = .default
            
            var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: time)
            dateComponents.second = 0
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            let request = UNNotificationRequest(identifier: "dailyReminder", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Failed to add notification: \(error.localizedDescription)")
                }
            }
            
            UserDefaultsManager.saveObject(time, forKey: UserDefaultsKeys.reminderTime)
        }
    }
    
    func removeNotifications(removeTime: Bool = false) {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        if removeTime {
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.reminderTime)
        }
    }
    
    private func showSettingsAlert() {
        AlertService.shared.showAlert(
            title: TextConstants.notificationsDisabled,
            message: TextConstants.enableNotificationsMessage,
            actionButtonTitle: TextConstants.toSettings
        ) {
            guard
                let settingsURL = URL(string: UIApplication.openSettingsURLString),
                UIApplication.shared.canOpenURL(settingsURL)
            else { return }
            
            UIApplication.shared.open(settingsURL)
        }
    }
}
