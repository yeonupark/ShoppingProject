//
//  DetailViewController.swift
//  ShoppingProject
//
//  Created by 마르 on 2023/09/10.
//

import UIKit
import WebKit
import RealmSwift

class DetailViewController: BaseViewController, WKUIDelegate {
    
    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    var isLiked: Bool = false
    var shoppingTable : ShoppingTable! = nil
    var shoppingItem = Item(title: "", image: "", lprice: "", mallName: "", productID: "")
    
    let repository = ShoppingTableRepository()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .white
        
        let heart = isLiked ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        let likeButton = UIBarButtonItem(image: heart, style: .plain, target: self, action: #selector(likeButtonClicked(sender: )))
        navigationItem.rightBarButtonItem = likeButton
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .black
        
        navigationController?.navigationBar.isTranslucent = false
        //navigationController?.navigationBar.standardAppearance = appearance
        //navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        showWebSite()
    }
    
    func showWebSite() {
        let productID = shoppingTable != nil ? shoppingTable.productID : shoppingItem.productID
        
        DispatchQueue.global().async {
            guard let myURL = URL(string:"https://msearch.shopping.naver.com/product/"+productID) else { return }
            let myRequest = URLRequest(url: myURL)
            DispatchQueue.main.async {
                self.webView.load(myRequest)
            }
        }
    }
    
    @objc func likeButtonClicked(sender: UIBarButtonItem) {
        
        if (shoppingTable != nil) { // 좋아요 페이지에서 상세 페이지로 들어간 경우
            if sender.image == UIImage(systemName: "heart") {
                self.repository.addItem(shoppingTable)
                sender.image = UIImage(systemName: "heart.fill")
            } else {
                repository.deleteItem(shoppingTable)
                sender.image = UIImage(systemName: "heart")
            }
                
        } else { // 검색 페이지에서 상세 페이지로 들어간 경우
            
            if sender.image == UIImage(systemName: "heart") {
                
                DispatchQueue.global().async {
                    guard let url = URL(string: self.shoppingItem.image) else { return }
                    let imageData = try! Data(contentsOf: url)
                    DispatchQueue.main.async {
                        let item = ShoppingTable(productName: self.shoppingItem.title, addedDate: Date(), mallName: self.shoppingItem.mallName, price: self.shoppingItem.lprice!, imageData: imageData, liked: true, productID: self.shoppingItem.productID)
                        self.repository.addItem(item)
                        self.view.makeToast("좋아요 목록에 추가되었습니다!")
                    }
                }
                sender.image = UIImage(systemName: "heart.fill")
                
            } else {
                repository.deleteItemFromProductID(self.shoppingItem.productID)
                self.view.makeToast("좋아요 목록에서 삭제되었습니다.")
                sender.image = UIImage(systemName: "heart")
            }
        }
    }
}
