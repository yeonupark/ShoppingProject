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
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        mainView.searchBar.endEditing(true)
        mainView.searchBar.text = ""
        
        tasks = repository.fetch()
        mainView.collectionView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
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
        
        guard let url = URL(string: data.imageURL ?? "") else { return cell }
        
        DispatchQueue.global().async {
            let imageData = try! Data(contentsOf: url)
            
            DispatchQueue.main.async {
                cell.imageView.image = UIImage(data: imageData)
            }
        }
        
        cell.likeButton.tag = indexPath.item
        cell.likeButton.addTarget(self, action: #selector(deleteItem(sender: )), for: .touchUpInside)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.productId = tasks[indexPath.item].productID
        vc.navigationItem.title = tasks[indexPath.item].productName
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func deleteItem(sender: UIButton) {
        repository.deleteItem(tasks[sender.tag])
        mainView.collectionView.reloadData()
    }

}
