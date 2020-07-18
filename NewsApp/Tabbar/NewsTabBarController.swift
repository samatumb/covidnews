//
//  NewsTabBarController.swift
//  NewsApp
//
//  Created by Samat on 16.07.2020.
//  Copyright © 2020 somfish. All rights reserved.
//

import UIKit

class NewsTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBar.appearance().tintColor = Colors.accent
        UINavigationBar.appearance().tintColor = Colors.accent
        
        viewControllers                 = [
            createNC(vc: TopNewsVC(), title: "Top News", SFSymbol: SFSymbols.top),
            createNC(vc: AllNewsVC(), title: "All News", SFSymbol: SFSymbols.all),
            createNC(vc: SavedNewsVC(), title: "Saved", SFSymbol: SFSymbols.saved)
        ]
    }
    
    
    func createNC(vc: UIViewController, title: String, SFSymbol: (UIImage?, UIImage?)) -> UINavigationController {
        let image               = SFSymbol.0
        let selectedImage       = SFSymbol.1
        vc.title                = title
        vc.tabBarItem           = UITabBarItem(title: title, image: image, selectedImage: selectedImage)
        
        return UINavigationController(rootViewController: vc)
    }
}
