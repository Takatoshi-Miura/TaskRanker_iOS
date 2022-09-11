//
//  AddTaskCoordinator.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2022/09/11.
//

import UIKit

class AddTaskCoordinator: Coordinator {
    
    var navigationController: UINavigationController?
    var previousViewController: UIViewController?
    
    func startFlow(in window: UIWindow?) {
    }
    
    func startFlow(in navigationController: UINavigationController) {
    }
    
    func startFlow(in viewController: UIViewController) {
        previousViewController = viewController
        let addTaskViewController = AddTaskViewController()
        addTaskViewController.delegate = self
        previousViewController!.present(addTaskViewController, animated: true)
    }
    
}

extension AddTaskCoordinator: AddTaskViewControllerDelegate {
    
    /// HomeVC ← AddTaskVC
    func addTaskVCDismiss(_ viewController: UIViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
}
