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
        navigationController = createNavigationController()
        let completedTaskListViewController = CompletedTaskListViewController()
        completedTaskListViewController.delegate = self
        navigationController!.pushViewController(completedTaskListViewController, animated: true)
        previousViewController!.present(navigationController!, animated: true)
    }
    
}

extension ComletedTaskListCoordinator: CompletedTaskListViewControllerDelegate {
    
    /// HomeVC ← CompletedTaskListVC
    func completedTaskListVCDismiss(_ viewController: UIViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    /// HomeVC ← CompletedTaskListVC
    func completedTaskListVCTaskInComplete(_ viewController: UIViewController, task: Task) {
        viewController.dismiss(animated: true, completion: nil)
        (previousViewController! as! HomeViewController).insertTask(task: task)
    }
    
}
