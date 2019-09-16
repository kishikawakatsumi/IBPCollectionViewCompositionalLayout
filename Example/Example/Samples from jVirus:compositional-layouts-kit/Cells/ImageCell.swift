//
//  ImageCell.swift
//  compositional-layouts-kit
//
//  Created by Astemir Eleev on 19/06/2019.
//  Copyright © 2019 Astemir Eleev. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell, ReuseIdentifiable {
    
    // MARK: - Properties
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = imageContentMode
        return imageView
    }()
    var imageContentMode: UIImageView.ContentMode = .scaleAspectFit {
        didSet {
            imageView.contentMode = imageContentMode
        }
    }
    var image: UIImage? = .init() {
        didSet {
            imageView.image = image
        }
    }
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Conformance to `Configurable` protocol
extension ImageCell: Configurable {
    func configure() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        
        let inset: CGFloat = 0.0
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset)
            ])
    }
}
