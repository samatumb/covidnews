//
//  PersistenceManager.swift
//  NewsApp
//
//  Created by Samat on 19.07.2020.
//  Copyright © 2020 somfish. All rights reserved.
//

import Foundation

enum PersistenceActionType {
    case add, remove
}

enum PersistenceManager {
    
    static private let defaults = UserDefaults.standard
    
    enum Keys { static let news = "news" }
    
    static func updateWith(article: NewsItem, actionType: PersistenceActionType, completed: @escaping (NewsError?) -> Void) {
        retrieveNews { result in
            switch result {
            case .success(var articles):
                
                switch actionType {
                case .add:
                    guard !articles.contains(article) else {
                        completed(.alreadySaved)
                        return
                    }
                    
                    articles.append(article)
                    
                case .remove:
                    articles.removeAll { $0.url == article.url }
                }
                
                completed(save(articles: articles))
                
            case .failure(let error):
                completed(error)
            }
        }
    }
    
    
    static func retrieveNews(completed: @escaping (Result<[NewsItem], NewsError>) -> Void) {
        guard let favoritesData = defaults.object(forKey: Keys.news) as? Data else {
            completed(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let articles = try decoder.decode([NewsItem].self, from: favoritesData)
            completed(.success(articles))
        } catch {
            completed(.failure(.unableToSave))
        }
    }
    
    static func save(articles: [NewsItem]) -> NewsError? {
        do {
            let encoder = JSONEncoder()
            let encodedArticles = try encoder.encode(articles)
            defaults.set(encodedArticles, forKey: Keys.news)
            return nil
        } catch {
            return .unableToSave
        }
    }
}

