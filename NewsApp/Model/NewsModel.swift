//
//  NewsModel.swift
//  NewsApp
//
//  Created by Samat on 16.07.2020.
//  Copyright © 2020 somfish. All rights reserved.
//

import Foundation

struct ResponseObject: Codable {
    var status: String
    var totalResults: Int
    var articles: [NewsItem]
}
struct NewsItem: Codable, Hashable {
    var title: String
    var url: String
    var urlToImage: String?
    var content: String?
    var publishedAt: String
    var author: String?
    var source: NewsSource
}

struct NewsSource: Codable, Hashable {
    var id: String?
    var name: String?
}
