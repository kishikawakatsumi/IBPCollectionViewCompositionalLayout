//
//  TitleView.swift
//  UICollectionViewCompositionalLayout
//
//  Created by Alex Gurin on 8/28/19.
//

import UIKit

class TitleView: UICollectionReusableView {
    @IBOutlet weak var titleLbl: UILabel!
    
    static let reuseIdentifier = "TitleView"

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
