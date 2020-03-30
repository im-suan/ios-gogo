//
//  STabBarView.swift
//  SShop
//
//  Created by Nguyen Xuan on 3/3/20.
//  Copyright © 2020 Nguyen Xuan. All rights reserved.
//

import UIKit

enum TabBarItemTag: Int {
    case home
    case category
    case cart
    case notification
    case account
}

protocol STabBarViewDelegate: class {
    func tabBarItemWasTapped(at: TabBarItemTag)
}

class STabBarView: UIView {
    //MARK: - outlets
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var homeTabItem: STabBarItem!
    @IBOutlet weak var categoryTabItem: STabBarItem!
    @IBOutlet weak var cartTabItem: STabBarItem!
    @IBOutlet weak var notificationTabItem: STabBarItem!
    @IBOutlet weak var accountTabItem: STabBarItem!
    
    //MARK: - variables
    var delegate: STabBarViewDelegate?
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        guard self.subviews.count == 0 else {
            return
        }
        commonInit()
    }

    func commonInit() {
        xibSetUp()
        setupTabBarItems()
    }
    
    private func xibSetUp() {
        contentView = loadNib(STabBarView.self)
        contentView.frame = self.bounds
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        
        NSLayoutConstraint.activate([
         contentView.topAnchor.constraint(equalTo: topAnchor),
         contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
         contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
         contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    func setupTabBarItems() {
        homeTabItem.tabBarItemButton.tag = TabBarItemTag.home.rawValue
        homeTabItem.delegate = self
        homeTabItem.backgroundColor = #colorLiteral(red: 0.9474372268, green: 0.2219972312, blue: 0.289686054, alpha: 1)

        categoryTabItem.tabBarItemButton.tag = TabBarItemTag.category.rawValue
        categoryTabItem.delegate = self
        categoryTabItem.backgroundColor = #colorLiteral(red: 0, green: 0.5864391923, blue: 1, alpha: 1)

        cartTabItem.tabBarItemButton.tag = TabBarItemTag.cart.rawValue
        cartTabItem.delegate = self
        cartTabItem.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)

        notificationTabItem.tabBarItemButton.tag = TabBarItemTag.notification.rawValue
        notificationTabItem.delegate = self
        notificationTabItem.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        
        accountTabItem.tabBarItemButton.tag = TabBarItemTag.account.rawValue
        accountTabItem.delegate = self
        accountTabItem.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
    }
}

//MARK: - STabBarItemDelegate
extension STabBarView: STabBarItemDelegate {
    func itemWasTapped(by sender: UIButton?) {
        guard let buttonTag = sender?.tag, let position = TabBarItemTag(rawValue: buttonTag), let delegate = delegate else {
            return
        }
        delegate.tabBarItemWasTapped(at: position)
    }
}
