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
    var tempTable : ShoppingTable! = nil
    var tempProductID: String = ""
    
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
        
        if (shoppingTable != nil) {
            tempTable = ShoppingTable(productName: shoppingTable.productName, addedDate: shoppingTable.addedDate, mallName: shoppingTable.mallName, price: shoppingTable.price, imageData: shoppingTable.imageData, liked: shoppingTable.liked, productID: shoppingTable.productID)
            tempProductID = shoppingTable.productID
        } else {
            tempProductID = shoppingItem.productID
        }
        
        showWebSite()
        
    }
    
    func showWebSite() {
        let productID = shoppingTable != nil ? shoppingTable.productID : shoppingItem.productID
       
        DispatchQueue.global().async {
            guard let myURL = URL(string: "https://msearch.shopping.naver.com/product/"+productID) else { return }
            let myRequest = URLRequest(url: myURL)
            DispatchQueue.main.async {
                self.webView.load(myRequest)
            }
        }
    }
    
    @objc func likeButtonClicked(sender: UIBarButtonItem) {
        
        
        if (shoppingTable != nil) { // 좋아요 페이지에서 상세 페이지로 들어간 경우
            if sender.image == UIImage(systemName: "heart") {
                if !tempTable.isInvalidated {
                    
                    if repository.containsProductID(tempProductID) {
                        sender.image = UIImage(systemName: "heart.fill")
                        return
                    }
                    
                    self.repository.addItem(tempTable!)
                    sender.image = UIImage(systemName: "heart.fill")
                    self.view.makeToast("좋아요 목록에 추가되었습니다!")
                } else {
                    self.view.makeToast("데이터를 불러올 수 없습니다. 검색화면에서 다시 시도해주세요")
                }
            } else {
                repository.deleteItemFromProductID(tempProductID)
                sender.image = UIImage(systemName: "heart")
                self.view.makeToast("좋아요 목록에서 삭제되었습니다.")
            }
                
        } else { // 검색 페이지에서 상세 페이지로 들어간 경우
            
            if sender.image == UIImage(systemName: "heart") {
                
                if repository.containsProductID(tempProductID) {
                    sender.image = UIImage(systemName: "heart.fill")
                    return
                }
                
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
