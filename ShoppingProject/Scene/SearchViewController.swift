//
//  SearchViewController.swift
//  ShoppingProject
//
//  Created by 마르 on 2023/09/07.
//

import UIKit

class SearchViewController: BaseViewController {
    
    let mainView = SearchView()
    
    override func loadView() {
        view.self = mainView
    }
    
    var shoppingList : [Item] = []
    var sortStandard = SortItem.accuracy
    let repository = ShoppingTableRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "상품 검색"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
        
        repository.checkSchemaVersion()

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
        setShoppingList(word: word)
        
    }
    
    @objc func latelyButtonClicked() {
        
        clickedButtonUIChange(idx: 1)
        
        sortStandard = SortItem.lately
        guard let word = mainView.searchBar.text else { return }
        setShoppingList(word: word)
        
    }
    
    @objc func cheapestButtonClicked() {
        
        clickedButtonUIChange(idx: 2)
        
        sortStandard = SortItem.cheap
        guard let word = mainView.searchBar.text else { return }
        setShoppingList(word: word)
        
    }
    
    @objc func mostExpensiveButtonClicked() {
        
        clickedButtonUIChange(idx: 3)
        
        sortStandard = SortItem.expensive
        guard let word = mainView.searchBar.text else { return }
        setShoppingList(word: word)
        
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
    
    func setShoppingList(word: String) {
        shoppingList.removeAll()
        
        ShoppingAPIManager.shared.callRequest(word, sort: sortStandard.rawValue) { data in
            for item in data.items {
                var title = item.title
                title = title.components(separatedBy: "<b>").joined()
                title = title.components(separatedBy: "</b>").joined()
                
                let productID = item.productID
                let imagePath = item.image
                let mallName = "[\(item.mallName)]"
                let price = item.lprice
                
                self.shoppingList.append(Item(title: title, image: imagePath, lprice: price, mallName: mallName, productID: productID))
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
        
        guard let word = mainView.searchBar.text else { return }
        setShoppingList(word: word)
        
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

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as? ProductCollectionViewCell else { return UICollectionViewCell() }
        
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
        
        if repository.containsProductID(data.productID) {
            cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            //cell.likeButton.addTarget(self, action: #selector(likeButtonUnClicked(sender: )), for: .touchUpInside)
        } //else {
            cell.likeButton.tag = indexPath.item
            cell.likeButton.addTarget(self, action: #selector(likeButtonClicked(sender: )), for: .touchUpInside)
        //}
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = DetailViewController()
        vc.productId = shoppingList[indexPath.item].productID
        vc.navigationItem.title = shoppingList[indexPath.item].title
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func likeButtonClicked(sender: UIButton) {
        
        let data = shoppingList[sender.tag]
        
        if sender.imageView?.image == UIImage(systemName: "heart") {
            
            let item = ShoppingTable(productName: data.title, mallName: data.mallName, price: data.lprice!, imageURL: data.image, liked: true, productID: data.productID)
            repository.addItem(item)
            sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            
        } else {
            
            repository.deleteItemFromProductID(data.productID)
            sender.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
    @objc func likeButtonUnClicked(sender: UIButton) {
        let data = shoppingList[sender.tag]
        let item = ShoppingTable(productName: data.title, mallName: data.mallName, price: data.lprice!, imageURL: data.image, liked: true, productID: data.productID)
        repository.deleteItem(item)
        sender.setImage(UIImage(systemName: "heart"), for: .normal)
    }
}


