//
//  ImageModel.swift
//  compositional-layouts-kit
//
//  Created by Astemir Eleev on 20/06/2019.
//  Copyright © 2019 Astemir Eleev. All rights reserved.
//

import UIKit

struct ImageModel: Hashable {
    let image: UIImage
    let identifier = UUID()
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}
