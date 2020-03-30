//
//  STabBarItem.swift
//  SShop
//
//  Created by Nguyen Xuan on 3/4/20.
//  Copyright © 2020 Nguyen Xuan. All rights reserved.
//

import UIKit

protocol STabBarItemDelegate: class {
    func itemWasTapped(by sender: UIButton?)
}

class STabBarItem: UIView {
    var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var tabBarItemButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
//        print("STabBarItem > return button")
        return button
    }()
        
    var delegate: STabBarItemDelegate?
    
    //MARK: - init
    override init(frame: CGRect) {
//        print("STabBarItem > init with frame")
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        print("STabBarItem > init with coder [subviews: \(self.subviews.count)]")
        guard self.subviews.count == 0 else {
            return
        }
        commonInit()
    }

    func commonInit() {
//        print("STabBarItem > common init add subviews")
        addSubview(contentView)
        NSLayoutConstraint.activate([
         contentView.topAnchor.constraint(equalTo: topAnchor),
         contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
         contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
         contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        contentView.addSubview(tabBarItemButton)
        NSLayoutConstraint.activate([
            tabBarItemButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            tabBarItemButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tabBarItemButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            tabBarItemButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
        tabBarItemButton.addTarget(self, action: #selector(tabBarItemTapped(_:)), for: .touchUpInside)
    }
    
    
    @objc func tabBarItemTapped(_ sender: UIButton) {
//        print("STabBarItem > tabBarItemTapped by \(sender.tag)")
        delegate?.itemWasTapped(by: sender)
    }
}
