//
//  SavedArticleCell.swift
//  NewsApp
//
//  Created by Samat on 19.07.2020.
//  Copyright © 2020 somfish. All rights reserved.
//

import UIKit

class SavedArticleCell: UITableViewCell {
    
    static let reuseID  = "SavedArticleCell"
    let articleImageView = ArticleImageView(isRounded: true)
    let articleLabel   = ArticleTitleLabel(textAlignment: .left, fontSize: 26)
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(article: NewsItem) {
        if let url = article.urlToImage {
            articleImageView.downloadImage(fromURL: url)
        }
        articleLabel.text = article.title
    }
    
    
    private func configure() {
        addSubviews(articleImageView, articleLabel)
        accessoryType           = .disclosureIndicator
        let padding: CGFloat    = 12
        
        NSLayoutConstraint.activate([
            articleImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            articleImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            articleImageView.heightAnchor.constraint(equalToConstant: 60),
            articleImageView.widthAnchor.constraint(equalToConstant: 60),
            
            articleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            articleLabel.leadingAnchor.constraint(equalTo: articleImageView.trailingAnchor, constant: 24),
            articleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            articleLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
