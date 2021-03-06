//
//  DateHelper.swift
//  MobileBanking
//
//  Created by Karin Lim on 13/03/22.
//

import Foundation

struct Converter{
    static func getFormattedDate(dateString: String, format: String) -> String {
        if dateString == ""{ return dateString}
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = format
        
        if let date = dateFormatterGet.date(from: dateString){
            return dateFormatterPrint.string(from: date)
        }
        return ""
    }
    
    static func formatToCurrency(_ amount: Double, isShowSymbol: Bool) -> String{
        let number = NSNumber(value: amount)
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = "SGD"
        if !isShowSymbol{
            formatter.currencySymbol = ""
        }
        formatter.locale = Locale(identifier: "en_SG")
        return formatter.string(from: number) ?? ""
    }
}
