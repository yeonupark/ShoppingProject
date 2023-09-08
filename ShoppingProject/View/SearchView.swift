//
//  SearchView.swift
//  ShoppingProject
//
//  Created by 마르 on 2023/09/07.
//

import UIKit

class SearchView: BaseView {
    
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
    
    let accuracyButton = {
        let view = UIButton()
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 1
        
        view.backgroundColor = .black
        view.titleLabel?.textColor = .white
        view.titleLabel?.font = .systemFont(ofSize: 15)
        view.setTitle("정확도", for: .normal)
        
        return view
    }()
    
    let latelyButton = {
        let view = UIButton()
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 1
        
        view.backgroundColor = .black
        view.titleLabel?.textColor = .white
        view.titleLabel?.font = .systemFont(ofSize: 15)
        view.setTitle("날짜순", for: .normal)
        
        return view
    }()
    
    let cheapestButton = {
        let view = UIButton()
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 1
        
        view.backgroundColor = .black
        view.titleLabel?.textColor = .white
        view.titleLabel?.font = .systemFont(ofSize: 15)
        view.setTitle("가격높은순", for: .normal)
        
        return view
    }()
    
    let mostExpensiveButton = {
        let view = UIButton()
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 1
        
        view.backgroundColor = .black
        view.titleLabel?.textColor = .white
        view.titleLabel?.font = .systemFont(ofSize: 15)
        view.setTitle("가격낮은순", for: .normal)
        
        return view
    }()
    
    lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        view.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: "SearchCollectionViewCell")
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
        
        for item in [searchBar, accuracyButton, latelyButton, mostExpensiveButton, cheapestButton, collectionView] {
            addSubview(item)
        }
    }
    
    override func setConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(8)
            make.height.equalTo(50)
        }

        accuracyButton.snp.makeConstraints { make in
            make.leading.equalTo(searchBar.snp.leading).inset(8)
            make.top.equalTo(searchBar.snp.bottom).offset(12)
            make.height.equalTo(36)
            make.width.equalTo(50)
        }

        latelyButton.snp.makeConstraints { make in
            make.leading.equalTo(accuracyButton.snp.trailing).offset(8)
            make.top.equalTo(searchBar.snp.bottom).offset(12)
            make.height.equalTo(36)
            make.width.equalTo(50)
        }

        cheapestButton.snp.makeConstraints { make in
            make.leading.equalTo(latelyButton.snp.trailing).offset(8)
            make.top.equalTo(searchBar.snp.bottom).offset(12)
            make.height.equalTo(36)
            make.width.equalTo(80)
        }

        mostExpensiveButton.snp.makeConstraints { make in
            make.leading.equalTo(cheapestButton.snp.trailing).offset(8)
            make.top.equalTo(searchBar.snp.bottom).offset(12)
            make.height.equalTo(36)
            make.width.equalTo(80)
        }
        
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.top.equalTo(accuracyButton.snp.bottom).offset(20)
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(20)
        }
    }
    
    
}
