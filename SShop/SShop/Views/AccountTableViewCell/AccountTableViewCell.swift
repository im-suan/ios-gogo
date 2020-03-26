//
//  AccountTableViewCell.swift
//  SShop
//
//  Created by Nguyen Xuan on 3/4/20.
//  Copyright © 2020 Nguyen Xuan. All rights reserved.
//

import UIKit

protocol AccountMenuItemDelegate {
    func viewDetail(of cell: AccountTableViewCell)
}

class AccountTableViewCell: UITableViewCell {
    //MARK: - outlets
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var detailButton: UIButton!
    
    //MARK: - variables
    var delegate: AccountMenuItemDelegate?
    var accountMenuItem: AccountMenuItem? {
        didSet {
            iconImage?.image = accountMenuItem?.icon
            titleLabel?.text = accountMenuItem?.title ?? ""
            if let total = accountMenuItem?.count {
                countLabel?.text = String(total)
            } else {
                countLabel?.text = nil
            }
            detailButton.isHidden = accountMenuItem?.hideButton ?? false
        }
    }
    
    //MARK: - init
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            delegate?.viewDetail(of: self)
        }
    }
    
    //MARK: - actions
    @IBAction func viewDetailButtonTapped(_ sender: UIButton) {
        delegate?.viewDetail(of: self)
    }
}
