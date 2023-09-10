//
//  MyShoppingListView.swift
//  ShoppingProject
//
//  Created by 마르 on 2023/09/10.
//

import UIKit

class MyShoppingListView: BaseView {
    
    let searchBar = {
        let view = UISearchBar()
        view.placeholder = "검색어를 입력해보세요!"
        
        view.setValue("취소", forKey: "cancelButtonText")
        view.showsCancelButton = true
        
        view.barTintColor = .clear
        view.backgroundColor = .darkGray
        view.searchTextField.textColor = .white
        
        
        return view
    }()
    
    lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        view.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: "ProductCollectionViewCell")
        view.collectionViewLayout = collectionViewLayout()
        view.backgroundColor = .black
        
        return view
    }()
    
    private func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        let size = UIScreen.main.bounds.width - 64
        layout.itemSize = CGSize(width: size/2, height: size/1.2)
        return layout
    }
    
    override func configure() {
        addSubview(searchBar)
        addSubview(collectionView)
    }
    
    override func setConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(8)
            make.height.equalTo(50)
        }
        
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.top.equalTo(searchBar.snp.bottom).offset(20)
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(20)
        }
    }
}
