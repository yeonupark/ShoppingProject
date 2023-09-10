//
//  SearchCollectionViewCell.swift
//  ShoppingProject
//
//  Created by 마르 on 2023/09/08.
//

import UIKit
import SnapKit

class ProductCollectionViewCell: BaseCollectionViewCell {
    
    let imageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.backgroundColor = .white
        
        return view
    }()
    
    let likeButton = {
        let view = UIButton()
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        view.backgroundColor = .white
        view.tintColor = .black
        
        return view
    }()
    
    let mallName = {
        let view = UILabel()
        view.textColor = .gray
        view.font = .systemFont(ofSize: 15)
        
        return view
    }()
    
    let title = {
        let view = UILabel()
        view.textColor = .white
        view.font = .systemFont(ofSize: 15)
        view.numberOfLines = 2
        
        return view
    }()
    
    let price = {
        let view = UILabel()
        view.textColor = .white
        view.font = .boldSystemFont(ofSize: 18)
        
        return view
    }()
    
    override func configure() {
        for item in [imageView, likeButton, mallName, title, price] {
            contentView.addSubview(item)
        }
    }
    
    override func setConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.height.equalTo(contentView.snp.width)
        }
        likeButton.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(imageView).inset(8)
            make.size.equalTo(40)
        }
        mallName.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.leading.equalTo(imageView.snp.leading)
            make.height.equalTo(18)
        }
        title.snp.makeConstraints { make in
            make.top.equalTo(mallName.snp.bottom).offset(2)
            make.leading.equalTo(imageView.snp.leading)
            make.trailing.equalTo(imageView.snp.trailing)
        }
        price.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(2)
            make.leading.equalTo(imageView.snp.leading)
            make.height.equalTo(18)
        }
    }
}
