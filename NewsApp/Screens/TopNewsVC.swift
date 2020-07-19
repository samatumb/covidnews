//
//  TopNewsVC.swift
//  NewsApp
//
//  Created by Samat on 16.07.2020.
//  Copyright © 2020 somfish. All rights reserved.
//

import UIKit

class TopNewsVC: DataLoadingVC {
    
    enum Section { case main }
    
    var news: [NewsItem] = []
    var page = 1
    let pageSize = 15
    let timeInterval = 5.0
    var isTimerActive = true
    var hasMoreArticles = true
    var isLoading       = false
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, NewsItem>!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        getNews()
        configureDataSource()
        getNewsByTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        isTimerActive = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        isTimerActive = true
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createTwoColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(ArticleCell.self, forCellWithReuseIdentifier: ArticleCell.reuseID)
    }
    
    
    func getNews() {
        showLoadingView()
        isLoading = true
        NetworkManager.shared.getNews(endpoint: .top, pageSize: pageSize, page: page) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            switch result {
            case .success(let responseObject):
                self.updateUI(with: responseObject.articles)
            case .failure(let error):
                self.presentAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
        isLoading = false
    }
    
    func getNewsByTimer() {
        
        Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true, block: { [weak self] timer in
            guard let self = self, self.isTimerActive else { return }
            
            self.isLoading = true
            NetworkManager.shared.getNews(endpoint: .top, pageSize: self.news.count, page: 1) { [weak self] result in
                guard let self = self, self.isTimerActive else { return }
                
                switch result {
                case .success(let responseObject):
                    self.updateUIByTimer(with: responseObject.articles)
                case .failure(let error):
                    print(error.rawValue)
                }
            }
            self.isLoading = false
        })
        
    }
    
    func updateUI(with articles: [NewsItem]) {
        if articles.count < pageSize { hasMoreArticles = false }
        news.append(contentsOf: articles)
        
        if self.news.isEmpty {
            showEmptyState()
            return
        }
        
        self.updateData(on: news)
    }
    
    func showEmptyState() {
        let message = "No Top news about Covid today 😀"
        DispatchQueue.main.async { self.showEmptyStateView(with: message, in: self.view) }
    }
    
    func updateUIByTimer(with articles: [NewsItem]) {
        if articles.isEmpty { return }
        
        for i in articles.indices {
            if !news.contains(articles[i]) {
                news.removeLast()
                news.insert(articles[i], at: 0)
                self.updateData(on: news)
            }
        }
    }
    
    func updateData(on news: [NewsItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, NewsItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(news)
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
    }
    
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, NewsItem>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, article) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArticleCell.reuseID, for: indexPath) as! ArticleCell
            cell.set(article: article)
            return cell
        })
    }
    
    
    
}


extension TopNewsVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let article = news[indexPath.item]
        let destVC          = DetailNewsVC()
        destVC.set(article: article)
        
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let offsetY         = scrollView.contentOffset.y
        let contentHeight   = scrollView.contentSize.height
        let height          = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard hasMoreArticles, !isLoading else { return }
            page += 1
            isTimerActive = false
            getNews()
            isTimerActive = true
        }
    }
}
