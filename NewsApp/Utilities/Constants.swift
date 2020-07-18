//
//  Constants.swift
//  NewsApp
//
//  Created by Samat on 18.07.2020.
//  Copyright © 2020 somfish. All rights reserved.
//

import UIKit

enum Images {
    static let placeholder    = UIImage(named: "article-placeholder")
    static let emptyStateLogo = UIImage(named: "empty-state-logo")
}

enum Colors {
    static let accent = UIColor.systemPink
}

enum SFSymbols {
    static let top = (
        UIImage(systemName: "star"),
        UIImage(systemName: "star.fill")
    )
    static let all = (
        UIImage(systemName: "rectangle.grid.2x2"),
        UIImage(systemName: "rectangle.grid.2x2.fill")
    )
    static let saved = (
        UIImage(systemName: "bookmark"),
        UIImage(systemName: "bookmark.fill")
    )
}
