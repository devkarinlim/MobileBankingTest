//
//  TransferModel.swift
//  MobileBanking
//
//  Created by Karin Lim on 14/03/22.
//

import Foundation

struct TransferDataSend: Codable{
    var receipientAccountNo: String
    var amount: Double
    var description : String
    
    func encodeToJSON()-> Data{
        let encoder = JSONEncoder()
        let jsonData = try! encoder.encode(self)
        return jsonData
    }
}

struct TransferDataResponse: Codable{
    var transactionId: String?
    var recipientAccount: String?
    var amount: Double?
    var description : String?
    var status: String
    var error: String?
}
