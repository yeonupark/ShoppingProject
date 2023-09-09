//
//  DetailViewController.swift
//  ShoppingProject
//
//  Created by 마르 on 2023/09/10.
//

import UIKit
import WebKit

class DetailViewController: BaseViewController, WKUIDelegate {
    
    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    var productId: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .white
        let likeButton = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: .none)
        navigationItem.rightBarButtonItem = likeButton
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .black
        
        navigationController?.navigationBar.isTranslucent = false
        //navigationController?.navigationBar.standardAppearance = appearance
        //navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        DispatchQueue.global().async {
            guard let myURL = URL(string:"https://msearch.shopping.naver.com/product/"+self.productId) else { return }
            let myRequest = URLRequest(url: myURL)
            DispatchQueue.main.async {
                self.webView.load(myRequest)
            }
        }
    }
}
