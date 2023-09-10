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
    @Persisted var addedDate: Date
    @Persisted var productName: String
    @Persisted var mallName: String
    @Persisted var price: String
    @Persisted var imageData: Data?
    @Persisted var liked: Bool //
    @Persisted var productID: String
    
    convenience init(productName: String, addedDate: Date, mallName: String, price: String, imageData: Data?, liked: Bool, productID: String) {
        self.init()
        
        self.productName = productName
        self.addedDate = addedDate
        self.mallName = mallName
        self.price = price
        self.imageData = imageData
        self.liked = true
        self.productID = productID
    }
}
