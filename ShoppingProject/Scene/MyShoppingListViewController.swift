//
//  MyShoppingListViewController.swift
//  ShoppingProject
//
//  Created by 마르 on 2023/09/10.
//

import UIKit

class MyShoppingListViewController: BaseViewController {
    
    let mainView = MyShoppingListView()
    
    override func loadView() {
        view.self = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "좋아요 목록"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
        
        //mainView.collectionView.delegate = self
        //mainView.collectionView.dataSource = self
    }
    
}

extension MyShoppingListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        mainView.searchBar.endEditing(true)
        
        guard let word = mainView.searchBar.text else { return }
        //setShoppingList(word: word)
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        mainView.searchBar.endEditing(true)
        mainView.searchBar.text = ""
        
        //shoppingList.removeAll()
        mainView.collectionView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
}


//extension MyShoppingListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//    }
//
//
//}
