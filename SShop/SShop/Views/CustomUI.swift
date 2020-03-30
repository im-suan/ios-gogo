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
    
    func loadNib<T: UIView>(_ view: T.Type) -> T {
        let nibName = String(describing: view)
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as! T
    }
}

extension UITableView {
    func registerCell<T: UITableViewCell>(_ cell: T.Type) {
        let nibName = String(describing: cell)
        let nib = UINib(nibName: nibName, bundle: nil)
        let cellName = String(describing: cell)
        self.register(nib, forCellReuseIdentifier: cellName)
    }
    
    func dequeueCell<T: UITableViewCell>(_ cell: AnyClass, at: IndexPath) -> T! {
        let cellName = String(describing: cell)
        guard let cell = dequeueReusableCell(withIdentifier: cellName, for: at) as? T else {
            fatalError("\(cellName) is not registed")
        }
        return cell
    }
}

