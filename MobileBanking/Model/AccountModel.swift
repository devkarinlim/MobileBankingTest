//
//  AccountModel.swift
//  MobileBanking
//
//  Created by Karin Lim on 13/03/22.
//

import Foundation

struct AccountResponse : Codable{
    var status: String
    var error: String?
    var data: [AccountData]
}

struct AccountData: Codable{
    var accountNo: String
    var accountHolder: String?
    var name: String?
    var id: String?
    
}
