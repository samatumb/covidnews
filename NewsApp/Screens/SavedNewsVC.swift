//
//  SavedNewsVC.swift
//  NewsApp
//
//  Created by Samat on 16.07.2020.
//  Copyright © 2020 somfish. All rights reserved.
//

import UIKit

class SavedNewsVC: DataLoadingVC {
    
    let tableView        = UITableView()
    var news: [NewsItem] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentAlertOnMainThread(title: "Saved News", message: "Swipe Left to remove from Saved", buttonTitle: "Ok")
        configureViewController()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getSavedNews()
    }
    
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    func configureTableView() {
        view.addSubview(tableView)
        
        tableView.frame         = view.bounds
        tableView.rowHeight     = 80
        tableView.delegate      = self
        tableView.dataSource    = self
        tableView.removeExcessCells()
        
        tableView.register(SavedArticleCell.self, forCellReuseIdentifier: SavedArticleCell.reuseID)
    }
    
    
    func getSavedNews() {
        PersistenceManager.retrieveNews { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let articles):
                self.updateUI(with: articles)
                
            case .failure(let error):
                self.presentAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    
    func updateUI(with articles: [NewsItem]) {
        if articles.isEmpty {
            self.showEmptyStateView(with: "No Saved news\nAdd one on News screen.", in: self.view)
        } else {
            self.news = articles
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.view.bringSubviewToFront(self.tableView)
            }
        }
    }
}

extension SavedNewsVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell        = tableView.dequeueReusableCell(withIdentifier: SavedArticleCell.reuseID) as! SavedArticleCell
        let article    = news[indexPath.row]
        cell.set(article: article)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = news[indexPath.item]
        let destVC  = DetailNewsVC()
        destVC.set(article: article)
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        PersistenceManager.updateWith(article: news[indexPath.row], actionType: .remove) { [weak self] error in
            guard let self = self else { return }
            guard let error = error else {
                self.news.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .left)
                return
            }
            self.presentAlertOnMainThread(title: "Unable to remove", message: error.rawValue, buttonTitle: "Ok")
            
        }
        
    }
}

