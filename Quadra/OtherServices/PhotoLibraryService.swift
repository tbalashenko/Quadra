//
//  PhotoLibraryService.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 11/07/2024.
//

import UIKit
import Photos

final class PhotoLibraryService {
    
    static func checkPhotoLibraryAccess(completion: @escaping (Bool) -> Void) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            completion(false)
            return
        }
        
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
            case .authorized:
                completion(true)
                
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization { newStatus in
                    DispatchQueue.main.async {
                        completion(newStatus == .authorized)
                    }
                }
                
            case .denied, .restricted, .limited:
                showSettingsAlert()
                completion(false)
                
            @unknown default:
                showSettingsAlert()
                completion(false)
        }
    }
    
    static func showSettingsAlert() {
        AlertService.shared.showAlert(
            title: TextConstants.allowAccessToPhotos,
            message: TextConstants.allowPhotoAccessMessage,
            actionButtonTitle: TextConstants.toSettings) {
                guard
                    let settingsURL = URL(string: UIApplication.openSettingsURLString),
                    UIApplication.shared.canOpenURL(settingsURL)
                else { return }
                
                UIApplication.shared.open(settingsURL)
            }
    }
}
