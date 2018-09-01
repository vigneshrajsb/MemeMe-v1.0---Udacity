//
//  CustomTextField.swift
//  MemeMe v1.0 - Udacity
//
//  Created by Vigneshraj Sekar Babu on 8/30/18.
//  Copyright © 2018 Vigneshraj Sekar Babu. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {

    override func caretRect(for position: UITextPosition) -> CGRect {
        return CGRect.zero
    }
    
    
}
