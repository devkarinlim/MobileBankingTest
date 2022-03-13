//
//  ErrorResponse.swift
//  MobileBanking
//
//  Created by Karin Lim on 13/03/22.
//

import Foundation

struct ErrorResponse: Codable{
    var name: String
    var message: String
    var expiredAt: String?
}
