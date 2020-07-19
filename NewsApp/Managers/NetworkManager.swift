//
//  NetworkManager.swift
//  NewsApp
//
//  Created by Samat on 16.07.2020.
//  Copyright © 2020 somfish. All rights reserved.
//

import UIKit

class NetworkManager {
    
    enum EndPoint: String {
        case top = "top-headlines?"
        case all = "everything?"
    }
    
    static let shared = NetworkManager()
    private let baseURL = "https://newsapi.org/v2/"
    //private let country = "us"
    private let category = "health"
    private let keyword = "covid"
    private let apikey  = "e65ee0938a2a43ebb15923b48faed18d" //95474305f6064687a233dd57edb94edf
    
    
    private init() {}
    
    func getNews(endpoint: EndPoint, pageSize: Int, page: Int, completed: @escaping (Result<ResponseObject, NewsError>) -> Void) {
        let request = baseURL + endpoint.rawValue  + "q=\(keyword)" +  "&pageSize=\(pageSize)" + "&page=\(page)" + "&apiKey=\(apikey)"
            //"country=\(country)" + + "category=\(category)"
        
        //print(request)
        guard let url = URL(string: request) else {
            completed(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completed(.failure(.unableToComplete))
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let responseObject = try decoder.decode(ResponseObject.self, from: data)
                var object = responseObject
                object.articles = Array(Set(object.articles))
                object.articles.sort{ ($0.publishedAt, $0.title) > ($1.publishedAt, $1.title) }
                completed(.success(object))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
    
    func downloadImage(from urlString: String, completed: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completed(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                let data = data,
                let image = UIImage(data: data) else {
                    completed(nil)
                    return
                }
            
            completed(image)
        }
        task.resume()
    }
}
