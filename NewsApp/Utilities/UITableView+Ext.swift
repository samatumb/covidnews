//
//  UITableView+Ext.swift
//  NewsApp
//
//  Created by Samat on 19.07.2020.
//  Copyright © 2020 somfish. All rights reserved.
//

import UIKit

extension UITableView {
    
    func reloadDataOnMainThread() {
        DispatchQueue.main.async { self.reloadData() }
    }
    
    
    func removeExcessCells() {
        tableFooterView = UIView(frame: .zero)
    }
}
