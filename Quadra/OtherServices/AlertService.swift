//
//  AlertService.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 04/07/2024.
//

import UIKit

final class AlertService {
    static let shared = AlertService()
    
    private init() { }
    
    func showAlert(
        title: String,
        message: String,
        actionButtonTitle: String,
        preferredStyle: UIAlertController.Style = .alert,
        action: @escaping ()->(),
        cancelAction: (()->())? = nil
    ) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: preferredStyle
        )
        
        let cancelAction = UIAlertAction(title: TextConstants.cancel, style: .cancel, handler: nil)
        let action = UIAlertAction(title: actionButtonTitle, style: .default) { _ in action() }
        
        alertController.addAction(cancelAction)
        alertController.addAction(action)
        
        
        if let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            
            windowScene.windows.first?.rootViewController?.presentedViewController?.present(alertController, animated: true, completion: nil)
        }
    }
}
