//
//  TransactionApi.swift
//  MobileBanking
//
//  Created by Karin Lim on 13/03/22.
//

import Foundation

class TransactionApi: NSObject{
    
    static func getAllTransactions(successCompletion: @escaping([TransactionData])->Void,failCompletion: @escaping(String)->Void){
        BaseApi.shared.GET(url: "transactions") { response in
            do{
                let transactionResponse = try JSONDecoder().decode(TransactionResponse.self, from: response as! Data)
                if transactionResponse.status == BaseApi.STATUS.SUCCESS.rawValue {
                    successCompletion(transactionResponse.data)
                }
                else{
//                    failCompletion(transactionResponse.error?.message ?? "Unknown Error")
                }
            }
            catch let error{
                print("Error reading json file with content: \(error.localizedDescription)")
            }
        } failCompletion: { error in
            failCompletion(error)
        }

    }
}
