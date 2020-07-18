//
//  NewsError.swift
//  NewsApp
//
//  Created by Samat on 16.07.2020.
//  Copyright © 2020 somfish. All rights reserved.
//

import Foundation

enum NewsError: String, Error {
    
    case invalidURL       = "Request URL is invalid"
    case unableToComplete = "Unable to complete your request"
    case invalidResponse  = "Invalid response from the server"
    case invalidData      = "The data received from the server was invalid"
    
    case unableToSave     = "There was an error saving this article"
    case alreadySaved     = "You've already saved this article"
}
