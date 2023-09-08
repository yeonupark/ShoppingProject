//
//  ReusableProtocol.swift
//  ShoppingProject
//
//  Created by 마르 on 2023/09/07.
//

import UIKit

protocol ReusableViewProtocol: AnyObject {
    static var identifier: String { get }
    
}

extension UIViewController: ReusableViewProtocol {
    public static var identifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell: ReusableViewProtocol {
    public static var identifier: String {
        return String(describing: self)
    }
}
