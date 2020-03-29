//
//  BaseViewController.swift
//  SShop
//
//  Created by Nguyen Xuan on 3/27/20.
//  Copyright © 2020 Nguyen Xuan. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    func switchToView(_ vc: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        dismiss(animated: true, completion: {
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: animated, completion: completion)
        })
    }
    
    func showView(_ vc: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        present(vc, animated: animated, completion: completion)
    }
}
