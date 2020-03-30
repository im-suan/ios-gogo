//
//  LoginModule.swift
//  SShop
//
//  Created Nguyen Xuan on 3/11/20.
//  Copyright © 2020 Nguyen Xuan. All rights reserved.
//
//  Template generated by LinhVT - @linh.deli
//

import UIKit

class LoginModule: LoginBuilderProtocol {
    
    static func build() -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = LoginViewController(nibName: nil, bundle: nil)
        let interactor = LoginInteractor()
        let router = LoginRouter()
        let presenter = LoginPresenter(view: view, interactor: interactor, router: router)

        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        router.navigationController = AppDelegate.shared?.navigationController
           
        return view
    }
}
