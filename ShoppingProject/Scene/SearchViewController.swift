//
//  SearchViewController.swift
//  ShoppingProject
//
//  Created by 마르 on 2023/09/07.
//

import UIKit

class SearchViewController: BaseViewController {
    
    var shoppingList : [Item] = []
    let mainView = SearchView()
    
    override func loadView() {
        view.self = mainView
    }
    
    var sortStandard = SortItem.accuracy
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "상품 검색"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]

        //clickedButtonUIChange(idx: 0)
        mainView.accuracyButton.backgroundColor = .white
        mainView.accuracyButton.setTitleColor(.black, for: .normal)
        
        mainView.searchBar.delegate = self
        
        mainView.accuracyButton.addTarget(self, action: #selector(acurracyButtonClicked), for: .touchUpInside)
        mainView.latelyButton.addTarget(self, action: #selector(latelyButtonClicked), for: .touchUpInside)
        mainView.cheapestButton.addTarget(self, action: #selector(cheapestButtonClicked), for: .touchUpInside)
        mainView.mostExpensiveButton.addTarget(self, action: #selector(mostExpensiveButtonClicked), for: .touchUpInside)
        
    }
    
    @objc func acurracyButtonClicked() {
        
        clickedButtonUIChange(idx: 0)
        
        sortStandard = SortItem.accuracy
        guard let word = mainView.searchBar.text else { return }
        setCollectionView(word: word)
        
    }
    
    @objc func latelyButtonClicked() {
        
        clickedButtonUIChange(idx: 1)
        
        sortStandard = SortItem.lately
        guard let word = mainView.searchBar.text else { return }
        setCollectionView(word: word)
        
    }
    
    @objc func cheapestButtonClicked() {
        
        clickedButtonUIChange(idx: 2)
        
        sortStandard = SortItem.cheap
        guard let word = mainView.searchBar.text else { return }
        setCollectionView(word: word)
        
    }
    
    @objc func mostExpensiveButtonClicked() {
        
        clickedButtonUIChange(idx: 3)
        
        sortStandard = SortItem.expensive
        guard let word = mainView.searchBar.text else { return }
        setCollectionView(word: word)
        
    }
    
    func clickedButtonUIChange(idx: Int) {
        
        var buttonList = [mainView.accuracyButton, mainView.latelyButton, mainView.cheapestButton, mainView.mostExpensiveButton]
        let button = buttonList[idx]
        
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        
        buttonList.remove(at: idx)
        for item in buttonList {
            if item.backgroundColor == .white {
                item.backgroundColor = .black
                item.setTitleColor(.white, for: .normal)
            }
        }
    }
    
    func setCollectionView(word: String) {
        shoppingList.removeAll()
        
        ShoppingAPIManager.shared.callRequest(word, sort: sortStandard.rawValue) { data in
            for item in data.items {
                var title = item.title
                title = title.components(separatedBy: "<b>").joined()
                title = title.components(separatedBy: "</b>").joined()
                
                let link = item.link
                let imagePath = item.image
                let mallName = "[\(item.mallName)]"
                let price = item.lprice
                
                self.shoppingList.append(Item(title: title, link: link, image: imagePath, lprice: price, mallName: mallName))
            }
            self.mainView.collectionView.reloadData()
        }
    }
    
    override func configure() {
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        mainView.searchBar.endEditing(true)
        shoppingList.removeAll()
        
        guard let word = mainView.searchBar.text else { return }
        ShoppingAPIManager.shared.callRequest(word, sort: sortStandard.rawValue) { data in
            for item in data.items {
                var title = item.title
                title = title.components(separatedBy: "<b>").joined()
                title = title.components(separatedBy: "</b>").joined()
                
                let link = item.link
                let imagePath = item.image
                let mallName = "[\(item.mallName)]"
                let price = item.lprice
                
                self.shoppingList.append(Item(title: title, link: link, image: imagePath, lprice: price, mallName: mallName))
            }
            self.mainView.collectionView.reloadData()
        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        mainView.searchBar.endEditing(true)
        mainView.searchBar.text = ""
        shoppingList.removeAll()
        mainView.collectionView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = shoppingList.count
        count = count > 30 ? 30 : count
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionViewCell", for: indexPath) as? SearchCollectionViewCell else { return UICollectionViewCell() }
        
        let data = shoppingList[indexPath.item]
        
        cell.mallName.text = data.mallName
        cell.title.text = data.title
        cell.price.text = data.lprice
        
        guard let url = URL(string: data.image) else { return cell }
        
        DispatchQueue.global().async {
            let imageData = try! Data(contentsOf: url)
            
            DispatchQueue.main.async {
                cell.imageView.image = UIImage(data: imageData)
            }
        }
        
        return cell
    }
    
}


