//
//  ButtonExtension.swift
//  MobileBanking
//
//  Created by Karin Lim on 14/03/22.
//

import Foundation
import UIKit

extension UIButton{
    func setRoundedStyle(){
        self.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.layer.cornerRadius = 25
    }
    
    func setRoundedRed(){
        self.tintColor = .white
        self.backgroundColor = .red
        self.setRoundedStyle()
    }
    
    func setRoundedBorderRed(){
        self.tintColor = .red
        self.backgroundColor = .white
        self.layer.borderColor = UIColor(named: "red")?.cgColor
        self.layer.borderWidth = 2
        setRoundedStyle()
    }
}
