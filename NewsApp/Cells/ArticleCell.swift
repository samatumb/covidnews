//
//  ArticleCell.swift
//  NewsApp
//
//  Created by Samat on 16.07.2020.
//  Copyright © 2020 somfish. All rights reserved.
//

import UIKit

class ArticleCell: UICollectionViewCell {
    
    static let reuseID      = "ArticleCell"
    let articleImageView    = ArticleImageView(isRounded: true)
    let articleLabel        = ArticleTitleLabel(textAlignment: .left, fontSize: 16)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(article: NewsItem) {
        articleLabel.text   = article.title
        guard let url       = article.urlToImage else { return }
        articleImageView.downloadImage(fromURL: url)
    }
    
    
    private func configure() {
        addSubview(articleImageView)
        addSubview(articleLabel)
        
        NSLayoutConstraint.activate([
            articleImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            articleImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            articleImageView.widthAnchor.constraint(equalToConstant: 100),
            articleImageView.heightAnchor.constraint(equalToConstant: 100),
            
            
            articleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            articleLabel.leadingAnchor.constraint(equalTo: articleImageView.trailingAnchor, constant: 8),
            articleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            articleLabel.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
}
