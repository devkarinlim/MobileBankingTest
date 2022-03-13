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
        let alert = UIAlertController(title: "Login Failed", message: "\(message.capitalized)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        sender.present(alert, animated: true, completion: nil)
    }
}
