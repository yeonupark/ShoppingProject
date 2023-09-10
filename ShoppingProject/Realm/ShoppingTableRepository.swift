//
//  ShoppingTableRepository.swift
//  ShoppingProject
//
//  Created by 마르 on 2023/09/10.
//

import UIKit
import RealmSwift

protocol ShoppingTableRepositoryType: AnyObject {
    func checkSchemaVersion()
    func fetch() -> Results<ShoppingTable>
    func fetchFilter(_ keyword: String) -> Results<ShoppingTable>
    func addItem(_ item: ShoppingTable)
    func deleteItem(_ item: ShoppingTable)
}

class ShoppingTableRepository: ShoppingTableRepositoryType {
    
    private let realm = try! Realm()
    
    func checkSchemaVersion() {
        do {
            let version = try schemaVersionAtURL(realm.configuration.fileURL!)
            print("Schema Version: \(version)")
        } catch {
            print(error)
        }
    }
    
    func fetch() -> RealmSwift.Results<ShoppingTable> {
        
        let data = realm.objects(ShoppingTable.self).sorted(byKeyPath: "addedDate", ascending: false)
        return data
    }
    
    func fetchFilter(_ keyword: String) -> Results<ShoppingTable> {
        
        let result = realm.objects(ShoppingTable.self).where {
            
            $0.productName.contains(keyword)
        }
        
        return result
    }
    
    func addItem(_ item: ShoppingTable) {
        
        do {
            try realm.write {
                realm.add(item)
            }
        }
        catch {
            print(error)
        }
    }
    
    func deleteItem(_ item: ShoppingTable) {
        
        do {
            try realm.write {
                realm.delete(item)
            }
        }
        catch {
            print(error)
        }
    }
    
    func containsProductID(_ productID: String) -> Bool {
        
        let data = realm.objects(ShoppingTable.self)
        
        for item in data {
            if item.productID == productID {
                return true
            }
        }
        
        return false
    }
    
    func deleteItemFromProductID(_ productID: String) {
        let data = realm.objects(ShoppingTable.self)
        for item in data {
            if item.productID == productID {
                do {
                    try realm.write {
                        realm.delete(item)
                    }
                    return
                }
                catch {
                    print(error)
                }
            }
        }
    }
}
