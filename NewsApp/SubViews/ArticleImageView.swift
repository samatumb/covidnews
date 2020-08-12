//
//  ArticleImageView.swift
//  NewsApp
//
//  Created by Samat on 16.07.2020.
//  Copyright © 2020 somfish. All rights reserved.
//

import UIKit

class ArticleImageView: UIImageView {
    
    private var isRounded = false
    let placeholderImage  = Images.placeholder
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(isRounded: Bool) {
        self.init(frame: .zero)
        self.isRounded = isRounded
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        contentMode             = isRounded ? .scaleAspectFit : .scaleAspectFit
        if isRounded {
            layer.cornerRadius  = 8
            layer.borderWidth   = 1
            layer.borderColor   = UIColor.gray.cgColor
        }
        //clipsToBounds           = true
        image                   = placeholderImage
        backgroundColor         = UIColor.systemGray
        translatesAutoresizingMaskIntoConstraints = false
        
        
    }
    
    func getRatioHeight(superWidth: CGFloat) ->CGFloat {
        if let image = image {
            let imageWidth = image.size.width
            let imageHeight = image.size.height
            print(imageHeight)
            return superWidth * imageHeight / imageWidth
        } else {
            return 300
        }
    }
    
    func downloadImage(fromURL url: String) {
        NetworkManager.shared.downloadImage(from: url) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async { self.image = image }
        }
    }
}
