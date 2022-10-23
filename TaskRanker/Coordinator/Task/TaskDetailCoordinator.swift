//
//  TaskDetailCoordinator.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2022/10/23.
//

import UIKit

class TaskDetailCoordinator: Coordinator {
    
    var navigationController: UINavigationController?
    var previousViewController: UIViewController?
    
    func startFlow(in window: UIWindow?) {
    }
    
    func startFlow(in navigationController: UINavigationController) {
    }
    
    func startFlow(in navigationController: UINavigationController, task: Task) {
        let taskDetailViewController = TaskDetailViewController(task: task)
        taskDetailViewController.delegate = self
        navigationController.pushViewController(taskDetailViewController, animated: true)
    }
    
    func startFlow(in viewController: UIViewController) {
    }
    
}

extension TaskDetailCoordinator: TaskDetailViewControllerDelegate {
    
    /// 画面を閉じる
    func taskDetailVCDismiss(_ viewController: UIViewController, task: Task) {
        let taskManager = TaskManager()
        taskManager.updateTask(task: task)
    }
    
    
}
