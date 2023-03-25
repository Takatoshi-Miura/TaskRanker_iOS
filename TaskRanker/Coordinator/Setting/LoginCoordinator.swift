//
//  LoginCoordinator.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2022/10/11.
//

import UIKit

class LoginCoordinator: Coordinator {
    
    var navigationController: UINavigationController?
    var previousViewController: UIViewController?
    
    func startFlow(in window: UIWindow?) {
    }
    
    func startFlow(in navigationController: UINavigationController) {
        self.navigationController = navigationController
        let loginViewController = LoginViewController()
        loginViewController.delegate = self
        self.navigationController?.pushViewController(loginViewController, animated: true)
    }
    
    func startFlow(in viewController: UIViewController) {
    }
    
}

extension LoginCoordinator: LoginViewControllerDelegate {
    
    /// SettingVC ← LoginVC
    func loginVCUserDidLogin(_ viewController: UIViewController) {
        viewController.dismiss(animated: true, completion: {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "afterLogin"), object: nil)
        })
    }
    
    /// SettingVC ← LoginVC
    func loginVCUserDidLogout(_ viewController: UIViewController) {
        viewController.dismiss(animated: true, completion: {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "afterLogout"), object: nil)
        })
    }
    
}
