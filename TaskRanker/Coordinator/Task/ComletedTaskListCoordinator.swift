//
//  ComletedTaskListCoordinator.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2022/10/24.
//

import UIKit

class ComletedTaskListCoordinator: Coordinator {
    
    var navigationController: UINavigationController?
    var previousViewController: UIViewController?
    
    func startFlow(in window: UIWindow?) {
    }
    
    func startFlow(in navigationController: UINavigationController) {
    }
    
    func startFlow(in viewController: UIViewController) {
        previousViewController = viewController
        let completedTaskListViewController = CompletedTaskListViewController()
        completedTaskListViewController.delegate = self
        if #available(iOS 13.0, *) {
            completedTaskListViewController.isModalInPresentation = true
            completedTaskListViewController.modalPresentationStyle = .fullScreen
        }
        previousViewController!.present(completedTaskListViewController, animated: true)
    }
    
}

extension ComletedTaskListCoordinator: CompletedTaskListViewControllerDelegate {
    
    /// HomeVC ← CompletedTaskListVC
    func completedTaskListVCDismiss(_ viewController: UIViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
}
