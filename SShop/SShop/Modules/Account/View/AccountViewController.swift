//
//  AccountViewController.swift
//  SShop
//
//  Created by Nguyen Xuan on 3/4/20.
//  Copyright © 2020 Nguyen Xuan. All rights reserved.
//

import UIKit
import CoreData

enum DetailView: Int {
    case order, contact, policy, call, logout
}

class AccountViewController: UIViewController {
    //MARK: - outlets
    @IBOutlet weak var accountTopView: UIView!
    @IBOutlet weak var accountMenuTable: UITableView!
    @IBOutlet weak var tabBarView: STabBarView!
    @IBOutlet weak var accountInfoTopView: UIView!
    @IBOutlet weak var accountLoginView: UIView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    //MARK: - variables
    private let menu = [
        [DetailView.order, DetailView.contact],
        [DetailView.policy, DetailView.call],
        [DetailView.logout]
    ]
    var user: User? = nil
    var accountMenuItems: [[AccountMenuItem]] = []
    var presenter: AccountPresenterProtocol?
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        SLoginManager.shared.delegate = self
        tabBarView.delegate = self
        loadData()
        setupTable()
        setupTopView()
    }
    
    private func setupTopView() {
        accountInfoTopView.isHidden = (user == nil)
        accountLoginView.isHidden = !accountInfoTopView.isHidden
        
        if let user = user {
            userNameLabel.text = user.name
            userImage.image = user.picture
        }
    }
    
    private func setupTable() {
        accountMenuTable.delegate = self
        accountMenuTable.dataSource = self
        accountMenuTable.registerCell(AccountTableViewCell.self)
    }

    private func loadData() {
        user = SLoginManager.shared.getUser()
        accountMenuItems = [
            [AccountMenuItem(icon: #imageLiteral(resourceName: "orderChecklist"), title: "Quản lý đơn hàng", count: 5),
             AccountMenuItem(icon: #imageLiteral(resourceName: "bookmark"), title: "Sổ địa chỉ", count: 3)],
            [AccountMenuItem(icon: #imageLiteral(resourceName: "guaranteeChecked"), title: "Chính sách và điều khoản", count: nil),
             AccountMenuItem(icon: #imageLiteral(resourceName: "callCenter"), title: "Liên hệ 1900 1009", count: nil)]
        ]
        if user != nil {
            accountMenuItems.append([AccountMenuItem(icon: #imageLiteral(resourceName: "logout"), title: "Đăng xuất", count:nil, hideButton: true)])
        }
    }
    
    //MARK: - actions
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        presenter?.openLoginView()
    }
    
    @IBAction func editAccountInfoTapped(_ sender: UIButton) {
        print("edit account info tapped")
    }
}

// MARK: - Table view data source
extension AccountViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return accountMenuItems.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountMenuItems[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("AccountViewController > cellForRowAt \(indexPath.row)")
        let cell = tableView.dequeueCell(AccountTableViewCell.self, at: indexPath) as AccountTableViewCell
        cell.accountMenuItem = accountMenuItems[indexPath.section][indexPath.row]
        cell.delegate = self
        return cell
    }
}

extension AccountViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueCell(AccountTableViewCell.self, at: indexPath) as AccountTableViewCell
        viewDetail(of: cell)
    }
}

//MARK: - AccountMenuItemDelegate
extension AccountViewController: AccountMenuItemDelegate {
    
    func viewDetail(of cell: AccountTableViewCell) {
        guard let cellIndex = accountMenuTable.indexPath(for: cell) else {
            return
        }
//        print("go to detail at section:\(cellIndex.section), row:\(cellIndex.row)")
        let detailView = menu[cellIndex.section][cellIndex.row]
        switch detailView {
        case .order:
            print("view order")
        case .contact:
            print("view contact")
        case .policy:
            print("view policy")
        case .call:
            print("view call")
        case .logout:
            print("logout")
            presenter?.performLogout()
        }
    }
}

//MARK: - AccountViewProtocol
extension AccountViewController: AccountViewProtocol {
    func reloadView() {
        loadData()
        setupTopView()
        accountMenuTable.reloadData()
    }
}

//MARK: - LoginManagerDelegate
extension AccountViewController: LoginManagerDelegate {
    func loginDidComplete() {
        print("login did complete")
        presenter?.loginCompleted()
    }
    
    func logoutDidComplete() {
        print("logout did complete")
        print("user ? nil: \(SLoginManager.shared.getUser() == nil ? true : false)")
        presenter?.logoutCompleted()
    }
}

//MARK: - STabBarViewDelegate
extension AccountViewController: STabBarViewDelegate {
    
    func tabBarItemWasTapped(at: TabBarItemTag) {
        print("AccountViewController tabBarItemWasTapped at \(at)")
        presenter?.tabBarTapped(tag: at)
    }
}
