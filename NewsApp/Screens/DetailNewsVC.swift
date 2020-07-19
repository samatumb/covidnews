//
//  DetailNewsVC.swift
//  NewsApp
//
//  Created by Samat on 17.07.2020.
//  Copyright © 2020 somfish. All rights reserved.
//

import UIKit

class DetailNewsVC: UIViewController {
    
    let scrollView          = UIScrollView()
    let contentView = UIView()
    
    let articleImageView = ArticleImageView(isRounded: false)
    let articleTitle = ArticleTitleLabel(textAlignment: .left, fontSize: 16)
    let articleBody = ArticleBodyLabel(textAlignment: .left)
    let articleDate = ArticleTitleLabel(textAlignment: .left, fontSize: 14)
    let articleAuthor = ArticleTitleLabel(textAlignment: .left, fontSize: 14)
    let linkButton    = LinkButton()
    
    var newsItem: NewsItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewControllers()
        configureScrollView()
        configure()
        configureLinkButton()
    }
    
    func configureViewControllers() {
        view.backgroundColor = .systemBackground
        
        let image            = SFSymbols.saved.0
        let saveButton       = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItem = saveButton
    }
    
    
    
    func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.pinToEdges(of: view)
        contentView.pinToEdges(of: scrollView)
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 800)
        ])
    }
    
    
    
    func set(article: NewsItem) {
        newsItem = article
        configureSubViews()
    }
    
    private func configureSubViews() {
        articleTitle.text = newsItem.title
        articleBody.text = newsItem.content
        articleDate.text = "Published at: \(newsItem.publishedAt)"
        
        title = newsItem.source.name ?? "Article"
        if let author = newsItem.author { articleAuthor.text = "Author: \(author)"}
        if let url = newsItem.urlToImage { articleImageView.downloadImage(fromURL: url) }
        
        
    }
    
    private func configure() {
        contentView.addSubviews(articleImageView, articleTitle, articleDate, articleAuthor, articleBody, linkButton)
        
        let padding: CGFloat = 12
        
        NSLayoutConstraint.activate([
            articleImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            articleImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            articleImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            articleImageView.heightAnchor.constraint(equalToConstant: 300),
            
            
            articleTitle.topAnchor.constraint(equalTo: articleImageView.bottomAnchor, constant: padding),
            articleTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            articleTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            articleDate.topAnchor.constraint(equalTo: articleTitle.bottomAnchor, constant: padding),
            articleDate.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            articleDate.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            articleAuthor.topAnchor.constraint(equalTo: articleDate.bottomAnchor, constant: padding),
            articleAuthor.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            articleAuthor.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            articleBody.topAnchor.constraint(equalTo: articleAuthor.bottomAnchor, constant: padding),
            articleBody.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            articleBody.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            linkButton.topAnchor.constraint(equalTo: articleBody.bottomAnchor, constant: padding),
            linkButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            linkButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            linkButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    
    private func configureLinkButton() {
        linkButton.set(backgroundColor: Colors.accent, title: "Open link")
        linkButton.addTarget(self, action: #selector(linkButtonTapped), for: .touchUpInside)
    }
    
    @objc func linkButtonTapped() {
        guard let url = URL(string: newsItem.url) else {
            presentAlertOnMainThread(title: "Invalid URL", message: "The url attached to News article is invalid.", buttonTitle: "Ok")
            return
        }
        
        presentSafariVC(with: url)
    }
    
 
    @objc func saveButtonTapped() {
        PersistenceManager.updateWith(article: newsItem, actionType: .add) { [weak self] error in
            guard let self = self else { return }
            guard let error = error else {
                self.presentAlertOnMainThread(title: "Success!", message: "You have successfully saved this article", buttonTitle: "Ok")
                return
            }
            self.presentAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
        }
    }
}
