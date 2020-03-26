//
//  User.swift
//  SShop
//
//  Created by Nguyen Xuan on 3/12/20.
//  Copyright © 2020 Nguyen Xuan. All rights reserved.
//

import UIKit
import Foundation

class User {
    var id: String
    var name: String = ""
    var picture: UIImage? = nil
    var email: String?
    var phone: String?
    var service: SSLoginService?
    
    init(id: String, name: String, service: SSLoginService, picture: UIImage? = nil, email: String? = nil, phone: String? = nil) {
        self.id = id
        self.name = name
        self.picture = picture
        self.email = email
        self.phone = phone
        self.service = service
    }
}
