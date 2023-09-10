//
//  RealmModel.swift
//  ShoppingProject
//
//  Created by 마르 on 2023/09/10.
//

import Foundation
import RealmSwift

class ShoppingTable: Object {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var productName: String
    @Persisted var mallName: String
    @Persisted var price: String
    @Persisted var imageURL: String?
    @Persisted var liked: Bool //
    @Persisted var productID: String
    
    convenience init(productName: String, mallName: String, price: String, imageURL: String?, liked: Bool, productID: String) {
        self.init()
        
        self.productName = productName
        self.mallName = mallName
        self.price = price
        self.imageURL = imageURL
        self.liked = true
        self.productID = productID
    }
}
