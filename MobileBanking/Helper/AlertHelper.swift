//
//  AlertHelper.swift
//  MobileBanking
//
//  Created by Karin Lim on 13/03/22.
//

import Foundation
import UIKit

class AlertHelper{
    
    static let shared = AlertHelper()
    
    func showError(title: String, message: String, sender: UIViewController){
        let alert = UIAlertController(title: title, message: "\(message.capitalized)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        sender.present(alert, animated: true, completion: nil)
    }
    
    func showSuccess(title: String, message: String, sender: UIViewController, confirmHandler: @escaping()->Void){
        let alert = UIAlertController(title: title, message: "\(message.capitalized)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            confirmHandler()
        }))
        sender.present(alert, animated: true, completion: nil)
    }
    
    func showConfirmation(title: String, message: String, sender: UIViewController, confirmHandler: @escaping()->Void, cancelHandler: @escaping()->Void){
        let alert = UIAlertController(title: title, message: "\(message)", preferredStyle: .alert)
        alert.setMessageAlignment(NSTextAlignment.left)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { cancel in
            cancelHandler()
        }))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { confirm in
            confirmHandler()
        }))
        sender.present(alert, animated: true, completion: nil)
    }
    
    func showSuccessLeft(title: String, message: String, sender: UIViewController, confirmHandler: @escaping()->Void){
        let alert = UIAlertController(title: title, message: "\(message)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            confirmHandler()
        }))
        alert.setMessageAlignment(.left)
        sender.present(alert, animated: true, completion: nil)
    }
    
}

extension UIAlertController{
    func setMessageAlignment(_ alignment : NSTextAlignment) {
            let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
            paragraphStyle.alignment = alignment

            let messageText = NSMutableAttributedString(
                string: self.message ?? "",
                attributes: [
                    NSAttributedString.Key.paragraphStyle: paragraphStyle,
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15),
                    NSAttributedString.Key.foregroundColor: UIColor.gray
                ]
            )

            self.setValue(messageText, forKey: "attributedMessage")
        }

}
