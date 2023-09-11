//
//  MyShoppingListViewController.swift
//  ShoppingProject
//
//  Created by 마르 on 2023/09/10.
//

import UIKit
import RealmSwift

class MyShoppingListViewController: BaseViewController {
    
    let mainView = MyShoppingListView()
    
    override func loadView() {
        view.self = mainView
    }
    
    var tasks: Results<ShoppingTable>!
    let repository = ShoppingTableRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "좋아요 목록"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
        
        mainView.searchBar.delegate = self
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        
        tasks = repository.fetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mainView.collectionView.reloadData()
    }
    
}

extension MyShoppingListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        mainView.searchBar.endEditing(true)
        
        guard let word = mainView.searchBar.text else { return }
        tasks = repository.fetchFilter(word)
        mainView.collectionView.reloadData()
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        mainView.searchBar.endEditing(true)
        mainView.searchBar.text = ""
        
        tasks = repository.fetch()
        mainView.collectionView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
}


extension MyShoppingListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tasks.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as? ProductCollectionViewCell else { return UICollectionViewCell() }
        
        let data = tasks[indexPath.item]
        cell.mallName.text = data.mallName
        cell.title.text = data.productName
        cell.price.text = data.price
        cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        
        if let imageData = data.imageData {
            cell.imageView.image = UIImage(data: imageData)
        } else {
            cell.imageView.image = UIImage(systemName: "nosign")
        }
        
        cell.likeButton.tag = indexPath.item
        cell.likeButton.addTarget(self, action: #selector(deleteItem(sender: )), for: .touchUpInside)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailViewController()
        
        if repository.containsProductID(tasks[indexPath.item].productID) {
            vc.isLiked = true
        } else {
            vc.isLiked = false
        }
        
        vc.shoppingTable = tasks[indexPath.item]
        vc.navigationItem.title = tasks[indexPath.item].productName
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func deleteItem(sender: UIButton) {
        repository.deleteItem(tasks[sender.tag])
        self.mainView.makeToast("좋아요 목록에서 삭제되었습니다.")
        mainView.collectionView.reloadData()
    }

}
