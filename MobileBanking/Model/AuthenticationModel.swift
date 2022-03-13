//
//  Authentication.swift
//  MobileBanking
//
//  Created by Karin Lim on 12/03/22.
//

import Foundation

struct AuthenticationSend: Codable{
    var username: String
    var password: String
    
    
    func encodeToJSON()-> Data{
        let encoder = JSONEncoder()
        let jsonData = try! encoder.encode(self)
        return jsonData
    }
    
}

struct AuthenticationResponse: Codable{
    var status: String
    var token: String?
    var username: String?
    var accountNo: String?
    var error: String?
    
    
}
