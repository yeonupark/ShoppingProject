//
//  TabBarController.swift
//  ShoppingProject
//
//  Created by 마르 on 2023/09/10.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTabBar()
 
    }
    
    func setTabBar() {
        tabBar.barTintColor = .black
        tabBar.tintColor = .white
        tabBar.isTranslucent = false
        
        let searchTab = UINavigationController(rootViewController: SearchViewController())
        let searchTabBarItem = UITabBarItem(title: "검색", image: UIImage(systemName: "magnifyingglass"), tag: 0)
        searchTab.tabBarItem = searchTabBarItem
        
        let myShoppingListTab = UINavigationController(rootViewController: MyShoppingListViewController()) 
        let myShoppingListTabBarItem = UITabBarItem(title: "좋아요", image: UIImage(systemName: "heart"), tag: 1)
        myShoppingListTab.tabBarItem = myShoppingListTabBarItem
        
        viewControllers = [searchTab, myShoppingListTab]
    }
}
