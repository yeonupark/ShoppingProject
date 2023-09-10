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
        
        let data = realm.objects(ShoppingTable.self)
        return data
    }
    
    func fetchFilter(_ keyword: String) -> Results<ShoppingTable> {
        
        let result = realm.objects(ShoppingTable.self) .where {
            
            $0.productName.contains("레몬")
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
    
}
