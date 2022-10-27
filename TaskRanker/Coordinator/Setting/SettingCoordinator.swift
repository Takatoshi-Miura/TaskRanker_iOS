//
//  SettingCoordinator.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2022/10/11.
//

import UIKit

class SettingCoordinator: Coordinator {
    
    var navigationController: UINavigationController?
    var previousViewController: UIViewController?
    
    func startFlow(in window: UIWindow?) {
    }
    
    func startFlow(in navigationController: UINavigationController) {
    }
    
    func startFlow(in viewController: UIViewController) {
        previousViewController = viewController
        navigationController = createNavigationController()
        let settingViewController = SettingViewController()
        settingViewController.delegate = self
        navigationController!.pushViewController(settingViewController, animated: true)
        previousViewController!.present(navigationController!, animated: true)
    }
    
}

extension SettingCoordinator: SettingViewControllerDelegate {
    
    /// HomeVC ← SettingVC
    func settingVCDismiss(_ viewController: UIViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    /// HomeVC → LoginVC
    func settingVCDataTransferDidTap(_ viewController: UIViewController) {
        let loginCoordinator = LoginCoordinator()
        loginCoordinator.startFlow(in: viewController)
    }
    
    /// HomeVC → TutorialVC
    func settingVCTutorialDidTap(_ viewController: UIViewController) {
        let pageCoordinator = PageCoordinator()
        pageCoordinator.startFlow(in: viewController)
    }
    
}

