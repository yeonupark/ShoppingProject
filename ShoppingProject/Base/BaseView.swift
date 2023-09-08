//
//  BaseView.swift
//  ShoppingProject
//
//  Created by 마르 on 2023/09/07.
//

import UIKit
import SnapKit

class BaseView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        backgroundColor = .black
    }
    
    func setConstraints() { }
}
