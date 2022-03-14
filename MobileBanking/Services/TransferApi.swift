//
//  TransferApi.swift
//  MobileBanking
//
//  Created by Karin Lim on 12/03/22.
//

import Foundation

class TransferApi: NSObject{
    
    static func getRecipients(successCompletion: @escaping([AccountData])->Void, failCompletion: @escaping(String)->Void){
        BaseApi.shared.GET(url: "payees") { response in
            do{
                let accountResp = try JSONDecoder().decode(AccountResponse.self, from: response as! Data)
                if accountResp.status == BaseApi.STATUS.SUCCESS.rawValue{
                    successCompletion(accountResp.data)
                }
                else{
                    failCompletion(accountResp.error ?? "Unknown Error")
                }
            }
            catch let error{
                failCompletion("\(error.localizedDescription)")
            }
        } failCompletion: { error in
            failCompletion(error)
        }
    }
    
    static func saveTransfer(data: TransferDataSend, successCompletion: @escaping(TransferDataResponse)->Void, failCompletion: @escaping(String)->Void){
        let body = data.encodeToJSON()
        BaseApi.shared.POST(url: "transfer", body: body) { response in
            do{
                let resp = try JSONDecoder().decode(TransferDataResponse.self, from: response as! Data)
                if resp.status == BaseApi.STATUS.SUCCESS.rawValue{
                    successCompletion(resp)
                }
                else{
                    failCompletion(resp.error ?? "Unknown Error")
                }
            }
            catch let error{
                failCompletion("\(error.localizedDescription)")
            }
        } failCompletion: { error in
            failCompletion(error)
        }

    }
    
}
