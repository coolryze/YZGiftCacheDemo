//
//  UILable+Extension.swift
//  YZTools
//
//  Created by heyuze on 16/7/11.
//  Copyright © 2016年 heyuze. All rights reserved.
//

import UIKit

extension UILabel {

    convenience init(text: String? = nil, textColor: UIColor, fontSize: CGFloat) {
        self.init()
        if text != nil {
            self.text = text
        }
        self.textColor = textColor
        self.font = UIFont.systemFont(ofSize: fontSize)
    }

}
