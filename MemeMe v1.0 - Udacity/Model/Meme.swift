//
//  Meme.swift
//  MemeMe v1.0 - Udacity
//
//  Created by Vigneshraj Sekar Babu on 8/30/18.
//  Copyright © 2018 Vigneshraj Sekar Babu. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    var topText: String
    var bottomText: String
    let originalImage: UIImage
    var memedImage: UIImage
    
    init(topText: String, bottomText: String, originalImage: UIImage, memedImage: UIImage){
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.memedImage = memedImage
    }
}
