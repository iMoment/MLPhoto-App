//
//  RoundedShadowButton.swift
//  MLPhoto
//
//  Created by Stanley Pan on 28/09/2017.
//  Copyright © 2017 Stanley Pan. All rights reserved.
//

import UIKit

class RoundedShadowButton: UIButton {

    override func awakeFromNib() {
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 15
        self.layer.shadowOpacity = 0.75
        self.layer.cornerRadius = self.frame.height / 2
    }
}
