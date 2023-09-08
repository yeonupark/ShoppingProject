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
    
    func callRequest(_ query: String, sort: String, completionHandler: @escaping (Shopping) -> Void) {
        
        let url = "https://openapi.naver.com/v1/search/shop.json"
        let header : HTTPHeaders = [
            "X-Naver-Client-Id": APIKey.naverShoppingID,
            "X-Naver-Client-Secret": APIKey.naverShoppingSecret
        ]
        let parameter : Parameters = ["query" : query, "sort" : sort]
        
        AF.request(url, method: .get, parameters: parameter, headers: header).validate()
            .responseDecodable(of: Shopping.self) { response in
                guard let value = response.value else {
                    print(response)
                    return
                }
                completionHandler(value)
        }
        
    }
}