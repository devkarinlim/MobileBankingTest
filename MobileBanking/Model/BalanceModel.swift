//
//  BalanceModel.swift
//  MobileBanking
//
//  Created by Karin Lim on 13/03/22.
//

import Foundation

struct BalanceData: Codable{
    var status: String
    var accountNo: String?
    var balance: Double?
    var error: ErrorResponse?
}
