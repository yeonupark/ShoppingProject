//
//  SearchViewController.swift
//  ShoppingProject
//
//  Created by 마르 on 2023/09/07.
//

import UIKit
import Toast

class SearchViewController: BaseViewController {
    
    let mainView = SearchView()
    
    override func loadView() {
        view.self = mainView
    }
    
    var shoppingList : [Item] = []
    var startIndex: Int = 1
    var page: Int = 1
    var sortStandard = SortItem.accuracy
    let repository = ShoppingTableRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "상품 검색"
        navigationItem.backButtonTitle = "상품 검색"
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mainView.collectionView.reloadData()
        mainView.searchBar.endEditing(true)
    }
    
    @objc func acurracyButtonClicked() {
        
        clickedButtonUIChange(idx: 0)
        sortStandard = SortItem.accuracy
        
        guard let word = mainView.searchBar.text else { return }
        setShoppingList(word: word)
//        if word != "" {
//            mainView.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
//        }
    }
    
    @objc func latelyButtonClicked() {
        
        clickedButtonUIChange(idx: 1)
        sortStandard = SortItem.lately
        
        guard let word = mainView.searchBar.text else { return }
        setShoppingList(word: word)
//        if word != "" {
//            mainView.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
//        }
    }
    
    @objc func cheapestButtonClicked() {
        
        clickedButtonUIChange(idx: 2)
        sortStandard = SortItem.cheap
        
        guard let word = mainView.searchBar.text else { return }
        setShoppingList(word: word)
//        if word != "" {
//            mainView.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
//        }
    }
    
    @objc func mostExpensiveButtonClicked() {
        
        clickedButtonUIChange(idx: 3)
        sortStandard = SortItem.expensive
        
        guard let word = mainView.searchBar.text else { return }
        setShoppingList(word: word)
//        if word != "" {
//            mainView.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
//        }
        
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
    
    func format(for number: Int) -> String {
            let numberFormat = NumberFormatter()
            numberFormat.numberStyle = .decimal
            return numberFormat.string(for: number)!
        }
    
    func showAlert(_ title: String) {
        let alert = UIAlertController(title: title, message: "네트워크 연결상태를 확인 후 다시 시도해주세요.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default)
        alert.addAction(ok)
        present(alert,animated: true)
    }
    
    func setShoppingList(word: String) {
        shoppingList.removeAll()
        ShoppingAPIManager.shared.callRequest(word, sort: sortStandard.rawValue, start: 1) { data in
            
            guard let data = data else {
                self.showAlert("데이터를 불러올 수 없습니다.")
                return
            }
            
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
        mainView.collectionView.prefetchDataSource = self
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        mainView.searchBar.endEditing(true)
        shoppingList.removeAll()
        
        guard let word = mainView.searchBar.text else { return }
        setShoppingList(word: word)
        startIndex = 1
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        mainView.searchBar.endEditing(true)
        mainView.searchBar.text = ""
        
        shoppingList.removeAll()
        mainView.collectionView.reloadData()
        startIndex = 1
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as? ProductCollectionViewCell else { return UICollectionViewCell() }
        
        let data = shoppingList[indexPath.item]
        
        cell.mallName.text = data.mallName
        cell.title.text = data.title
        if let price = Int(data.lprice) {
            cell.price.text = format(for: price)+"원"
        }
        
        guard let url = URL(string: data.image) else { return cell }
        
        DispatchQueue.global().async {
            let imageData = try! Data(contentsOf: url)
            
            DispatchQueue.main.async {
                cell.imageView.image = UIImage(data: imageData)
            }
        }
        
        if repository.containsProductID(data.productID) {
            cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        
        cell.likeButton.tag = indexPath.item
        cell.likeButton.addTarget(self, action: #selector(likeButtonClicked(sender: )), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if shoppingList.count - 1 == indexPath.row {
        
                guard let word = mainView.searchBar.text else { return}
                page += 1
                startIndex += 30
                print("page:",page,"startIndex:",startIndex)
                
                ShoppingAPIManager.shared.callRequest(word, sort: sortStandard.rawValue, start: startIndex) { data in
                    
                    guard let data = data else {
                        self.showAlert("데이터를 불러올 수 없습니다.")
                        return
                    }
                    
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
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = DetailViewController()
        vc.shoppingItem = shoppingList[indexPath.item]
        
        if repository.containsProductID(shoppingList[indexPath.item].productID) {
            vc.isLiked = true
        } else {
            vc.isLiked = false
        }
        
        vc.navigationItem.title = shoppingList[indexPath.item].title
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func likeButtonClicked(sender: UIButton) {
        
        let data = shoppingList[sender.tag]
        
        if sender.imageView?.image == UIImage(systemName: "heart") {
            
            DispatchQueue.global().async {
                guard let url = URL(string: data.image) else { return }
                let imageData = try! Data(contentsOf: url)
                DispatchQueue.main.async {
                
                    let item = ShoppingTable(productName: data.title, addedDate: Date(), mallName: data.mallName, price: data.lprice, imageData: imageData, liked: true, productID: data.productID)
                    self.repository.addItem(item)
                    self.mainView.makeToast("좋아요 목록에 추가되었습니다!")
                }
            }
            sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            
        } else {
            
            repository.deleteItemFromProductID(data.productID)
            self.mainView.makeToast("좋아요 목록에서 삭제되었습니다.")
            sender.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
}


