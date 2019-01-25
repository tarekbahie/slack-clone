//
//  RoundedCornerUIView.swift
//  slackClone
//
//  Created by tarek bahie on 1/20/19.
//  Copyright © 2019 tarek bahie. All rights reserved.
//

import UIKit

@IBDesignable class RoundedCornerUIView: UIView {

    @IBInspectable var cornerRadius : CGFloat = 15.0{
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    override func awakeFromNib() {
        setupView()
    }
    override func prepareForInterfaceBuilder() {
        setupView()
    }
    func setupView() {
        self.layer.cornerRadius = cornerRadius
        
    }

}
