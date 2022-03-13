//
//  TransactionModel.swift
//  MobileBanking
//
//  Created by Karin Lim on 13/03/22.
//

import Foundation

struct TransactionResponse: Codable{
    var status: String
    var error: ErrorResponse?
    var data: [TransactionData]
}

struct TransactionData: Codable{
    var transactionId: String
    var amount: Float
    var transactionDate: String
    var description: String?
    var transactionType: String
    var receipient: AccountData
}

struct TransactionPerDate{
    var formattedDate: String
    var detail: [TransactionData]
}

enum TransactionType: String{
    case TRANSFER = "transfer"
}


