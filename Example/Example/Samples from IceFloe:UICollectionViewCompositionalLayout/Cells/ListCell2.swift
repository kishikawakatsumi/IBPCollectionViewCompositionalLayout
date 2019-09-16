//
//  ListCell.swift
//  UICollectionViewCompositionalLayout
//
//  Created by Alex Gurin on 8/25/19.
//

import UIKit

class ListCell2: UICollectionViewCell {
    static let reuseIdentifier = "ListCell"

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureWith(text: String, image: UIImage?) {
        label.text = text
        imageView.image = image
    }
}
