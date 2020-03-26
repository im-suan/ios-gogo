//
//  CustomUI.swift
//  SShop
//
//  Created by Nguyen Xuan on 2/17/20.
//  Copyright © 2020 Nguyen Xuan. All rights reserved.
//

import UIKit

//MARK: - UIView extension
extension UIView {
    
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
}

