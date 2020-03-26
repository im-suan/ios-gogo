//
//  ShopViewController.swift
//  SShop
//
//  Created by Nguyen Xuan on 2/17/20.
//  Copyright © 2020 Nguyen Xuan. All rights reserved.
//

import UIKit

class ShopViewController: UIViewController {
    
    @IBOutlet weak var tabBarView: STabBarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarView.delegate = self
    }
}

extension ShopViewController: STabBarViewDelegate {
    
    func tabBarItemWasTapped(at: TabBarItemTag) {
        print("navigationController ? nil : \(navigationController == nil)")
        switch at {
        case .home:
            print("go to home")
            let vc = HomeModule.build()
//            vc.modalPresentationStyle = .overFullScreen
//            present(vc, animated: true, completion: nil)
            navigationController?.pushViewController(vc, animated: true)
        case .account:
            print("go to account")
            let vc = AccountModule.build()
//            vc.modalPresentationStyle = .overFullScreen
//            present(vc, animated: true, completion: nil)
            navigationController?.pushViewController(vc, animated: true)
        default:
            print("go to tag \(at)")
        }
    }
}
