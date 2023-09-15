//
//  APIManager.swift
//  ShoppingProject
//
//  Created by 마르 on 2023/09/08.
//

import UIKit
import Alamofire

class ShoppingAPIManager {
    
    static let shared = ShoppingAPIManager()
    
    private init() {}
    
    func callRequest(_ query: String, sort: String, start: Int, completionHandler: @escaping (Shopping?) -> Void) {
        
        let url = "https://openapi.naver.com/v1/search/shop.json"
        let header : HTTPHeaders = [
            "X-Naver-Client-Id": APIKeys.naverShoppingID,
            "X-Naver-Client-Secret": APIKeys.naverShoppingSecret
        ]
        let parameter : Parameters = ["query" : query, "sort" : sort, "display" : 30, "start" : start]
        
        AF.request(url, method: .get, parameters: parameter, headers: header).validate()
            .responseDecodable(of: Shopping.self) { response in
                guard let value = response.value else {
                    completionHandler(nil)
                    return
                }
                completionHandler(value)
        }
        
    }
}
