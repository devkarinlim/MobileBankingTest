//
//  BaseApi.swift
//  MobileBanking
//
//  Created by Karin Lim on 12/03/22.
//

import Foundation
import UIKit


let baseUrl = "https://green-thumb-64168.uc.r.appspot.com/"

class BaseApi: NSObject{
    
    static let shared = BaseApi()
    
    func POST(url: String, body: Data?,
              successCompletion: @escaping (Any) -> Void,
              failCompletion: @escaping (String) -> Void){
        if let requestURL = createUrl(url: url){
            var request = URLRequest(url: requestURL)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue(requestAuthToken(), forHTTPHeaderField: "Authorization")
            request.httpBody = body
            let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                UIViewController.removeSpinner()
                if (error != nil) {
                    print(error as Any)
                    failCompletion(error?.localizedDescription ?? "Error make a connection to server")
                } else {
                    if let dataFromAPI = data {
                        successCompletion(dataFromAPI)
                    }
                }
            }
            dataTask.resume()
        }
    }
    
    func GET(url: String,
              successCompletion: @escaping (Any) -> Void,
              failCompletion: @escaping (String) -> Void){
        if let requestURL = createUrl(url: url){
            var request = URLRequest(url: requestURL)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue(requestAuthToken(), forHTTPHeaderField: "Authorization")
            
            let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                UIViewController.removeSpinner()
                if (error != nil) {
                    print(error as Any)
                    failCompletion(error?.localizedDescription ?? "Error make a connection to server")
                } else {
                    if let dataFromAPI = data {
                        successCompletion(dataFromAPI)
                    }
                }
            }
            dataTask.resume()
        }
    }
    
    func createUrl(url: String)-> URL?{
        let urlString = "\(baseUrl)"+"\(url)"
        return URL(string: urlString)
    }
    
    func requestAuthToken()->String{
        if let authToken =  UserDefaults.standard.string(forKey: "authToken"){
            return authToken
        }
        else{
            return ""
        }
    }
    
    enum STATUS: String{
        case SUCCESS = "success"
        case FAILED = "failed"
    }
    
    //    After login
    //UserDefaults.standard.set(value, forKey: authToken)
    //UserDefaults.standard.removeObject(forKey: "authToken")
}

