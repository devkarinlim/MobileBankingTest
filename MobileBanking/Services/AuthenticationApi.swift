//
//  UserApi.swift
//  MobileBanking
//
//  Created by Karin Lim on 12/03/22.
//

import Foundation

class AuthenticationApi: NSObject{
    
    static func login(userData: AuthenticationSend,
                      successCompletion: @escaping (AuthenticationResponse) -> Void,
                      failCompletion: @escaping (String) -> Void){
        
            let body = userData.encodeToJSON()
            BaseApi.shared.POST(url: "login/", body: body) { response in
                do {
                    let authUser = try JSONDecoder().decode(AuthenticationResponse.self, from: response as! Data)
                    if authUser.status == BaseApi.STATUS.SUCCESS.rawValue {
                        successCompletion(authUser)
                    }
                    else{
                        failCompletion(authUser.error ?? "Unknown Error")
                    }
                } catch let error {
                    print("Error reading json file with content: \(error.localizedDescription)")
                }
            } failCompletion: { error in
                failCompletion(error)
            }
    }
    
    static func register(userData: AuthenticationSend,
                      successCompletion: @escaping (AuthenticationResponse) -> Void,
                      failCompletion: @escaping (String) -> Void){
        
            let body = userData.encodeToJSON()
            BaseApi.shared.POST(url: "register/", body: body) { response in
                do {
                    let authUser = try JSONDecoder().decode(AuthenticationResponse.self, from: response as! Data)
                    if authUser.status == BaseApi.STATUS.SUCCESS.rawValue {
                        successCompletion(authUser)
                    }
                    else{
                        failCompletion(authUser.error ?? "Unknown Error")
                    }
                } catch let error {
                    print("Error reading json file with content: \(error.localizedDescription)")
                }
            } failCompletion: { error in
                failCompletion(error)
            }
    }
}

