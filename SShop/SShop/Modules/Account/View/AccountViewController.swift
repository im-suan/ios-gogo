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
    static let cellId = "AccountTableCell"
    private let menu = [
        [DetailView.order, DetailView.contact],
        [DetailView.policy, DetailView.call],
        [DetailView.logout]
    ]
    private var isLogged: Bool = false {
        didSet {
            if isLogged != oldValue {
                reloadData()
            }
        }
    }
    var user: User? {
        didSet {
            isLogged = (user != nil)
        }
    }
    var accountMenuItems: [[AccountMenuItem]] = []
    var presenter: AccountPresenterProtocol?
    weak var ssLoginManager = SSLoginManager.shared
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("AccountViewController: view did load")
        ssLoginManager?.presentingViewController = self
        ssLoginManager?.delegate = self
        
        user = ssLoginManager?.getUser()
        print(user)
        print(isLogged)
        initData()
        tabBarView.delegate = self
        setupTable()
        setupTopView()
    }
    
    private func setupTopView() {
        accountInfoTopView.isHidden = !isLogged
        accountLoginView.isHidden = isLogged
        
        if isLogged, let user = user {
            userNameLabel.text = user.name
            userImage.image = user.picture
        }
    }
    
    private func setupTable() {
        accountMenuTable.delegate = self
        accountMenuTable.dataSource = self
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "AccountTableViewCell", bundle: bundle)
        accountMenuTable.register(nib, forCellReuseIdentifier: AccountViewController.cellId)
    }

    private func initData() {
        accountMenuItems = [
            [AccountMenuItem(icon: #imageLiteral(resourceName: "orderChecklist"), title: "Quản lý đơn hàng", count: 5),
             AccountMenuItem(icon: #imageLiteral(resourceName: "bookmark"), title: "Sổ địa chỉ", count: 3)],
            [AccountMenuItem(icon: #imageLiteral(resourceName: "guaranteeChecked"), title: "Chính sách và điều khoản", count: nil),
             AccountMenuItem(icon: #imageLiteral(resourceName: "callCenter"), title: "Liên hệ 1900 1009", count: nil)]
        ]
        if isLogged {
            accountMenuItems.append([AccountMenuItem(icon: #imageLiteral(resourceName: "logout"), title: "Đăng xuất", count:nil, hideButton: true)])
        }
    }
    
    private func reloadData() {
        initData()
        accountMenuTable?.reloadData()
    }
    
    //MARK: - actions
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        let vc = LoginModule.build()
        vc.modalPresentationStyle = .popover
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func editAccountInfoTapped(_ sender: UIButton) {
        print("edit account info tapped")
    }
    
}

extension AccountViewController: SSLoginManagerDelegate {
    func loginDidComplete() {
        print("login did complete")
        backToAccountView()
    }
    
    func logoutDidComplete() {
        print("logout did complete")
        backToAccountView()
    }
    
    private func backToAccountView() {
        guard let vc = AccountModule.build() as? AccountViewController else {
            return
        }
        print("user: \(ssLoginManager?.getUser())")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true, completion: nil)
    }
}

// MARK: - Table view data source
extension AccountViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print("number of sections: \(menu.count-1)")
        return isLogged ? menu.count : menu.count - 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("number of row in section[\(section)]: \(accountMenuItems[section].count)")
        return accountMenuItems[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("AccountViewController > cellForRowAt \(indexPath.row)")
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AccountViewController.cellId, for: indexPath) as? AccountTableViewCell else {
            fatalError("The dequeued cell is not an instance of \(AccountViewController.cellId).")
        }
        let item = accountMenuItems[indexPath.section][indexPath.row]
        print("s: \(indexPath.section), r: \(indexPath.row)")
        cell.accountMenuItem = item
        cell.delegate = self
        return cell
    }
}

extension AccountViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AccountViewController.cellId, for: indexPath) as? AccountTableViewCell else {
            fatalError("The dequeued cell is not an instance of \(AccountViewController.cellId).")
        }
        viewDetail(of: cell)
    }
}

//MARK: - AccountMenuItemDelegate
extension AccountViewController: AccountMenuItemDelegate {
    
    func viewDetail(of cell: AccountTableViewCell) {
        guard let cellIndex = accountMenuTable.indexPath(for: cell) else {
            return
        }
        print("go to detail at section:\(cellIndex.section), row:\(cellIndex.row)")
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
            ssLoginManager?.logout()
        }
    }
}

//MARK: - AccountViewProtocol
extension AccountViewController: AccountViewProtocol {
    
}

//MARK: - STabBarViewDelegate
extension AccountViewController: STabBarViewDelegate {
    
    func tabBarItemWasTapped(at: TabBarItemTag) {
        print("AccountViewController tabBarItemWasTapped at \(at)")
        switch at {
        case .home:
            let vc = HomeModule.build()
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: true, completion: nil)
            print("AccountViewController go to home")
        case .account:
            let vc = AccountModule.build()
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: true, completion: nil)
            print("AccountViewController go to account")
        default:
            print("AccountViewController go to tag \(at)")
        }
    }
}
