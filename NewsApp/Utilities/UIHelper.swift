//
//  UIHelper.swift
//  NewsApp
//
//  Created by Samat on 16.07.2020.
//  Copyright © 2020 somfish. All rights reserved.
//

import UIKit

enum UIHelper {
    
    static func createTwoColumnFlowLayout(in view: UIView)-> UICollectionViewFlowLayout {
        let width                       = view.bounds.width
        let padding: CGFloat            = 12
        let itemWidth                   = width - (padding * 2) - 12
        
        let flowLayout                  = UICollectionViewFlowLayout()
        flowLayout.sectionInset         = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize             = CGSize(width: itemWidth, height: 100)
        
        return flowLayout
    }
}

