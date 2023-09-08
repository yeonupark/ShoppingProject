//
//  Shopping.swift
//  ShoppingProject
//
//  Created by 마르 on 2023/09/08.
//

import Foundation


// MARK: - Shopping
struct Shopping: Codable {
    let lastBuildDate: String
    let total, start, display: Int
    let items: [Item]
}

// MARK: - Item
struct Item: Codable {
    let title: String
    let link: String
    let image: String
    let lprice: String?
    let mallName: String
    //let lprice, hprice, mallName, productID: String

    enum CodingKeys: String, CodingKey {
        case title, link, image, lprice, mallName
        //case productID = "productId"
    }
}
