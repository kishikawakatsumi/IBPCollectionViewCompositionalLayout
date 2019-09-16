//
//  BackgroundView.swift
//  UICollectionViewCompositionalLayout
//
//  Created by Alex Gurin on 8/28/19.
//

import UIKit

class BackgroundView: UICollectionReusableView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
}

extension BackgroundView {
    func configure() {
        backgroundColor = UIColor.white.withAlphaComponent(1)
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 0
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 5
        layer.shadowOpacity = 1
    }
}
