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
        AppDelegate.shared?.navigationController = navigationController
    }
}

extension ShopViewController: STabBarViewDelegate {
    
    func tabBarItemWasTapped(at: TabBarItemTag) {
        guard let nav = navigationController else {
            print("No navigationController")
            return
        }
        
        switch at {
        case .home:
            nav.pushViewController(HomeModule.build(), animated: true)
            print("AccountViewController go to home")
        case .account:
            nav.pushViewController(AccountModule.build(), animated: true)
            print("AccountViewController go to account")
        default:
            print("AccountViewController go to tag \(at)")
        }
    }
}
