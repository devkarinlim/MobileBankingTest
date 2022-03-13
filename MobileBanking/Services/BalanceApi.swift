//
//  BalanceApi.swift
//  MobileBanking
//
//  Created by Karin Lim on 13/03/22.
//

import Foundation

class BalanceApi: NSObject{
    
    static func getBalance(successCompletion: @escaping (BalanceData)->Void, failCompletion: @escaping(String)->Void){
        BaseApi.shared.GET(url: "balance") { response in
            do {
                let balanceData = try JSONDecoder().decode(BalanceData.self, from: response as! Data)
                if balanceData.status == BaseApi.STATUS.SUCCESS.rawValue {
                    successCompletion(balanceData)
                }
                else{
                    failCompletion(balanceData.error?.message ?? "Unknown Error")
                }
            } catch let error {
                print("Error reading json file with content: \(error.localizedDescription)")
            }
        } failCompletion: { error in
            failCompletion(error)
        }
    }
}
