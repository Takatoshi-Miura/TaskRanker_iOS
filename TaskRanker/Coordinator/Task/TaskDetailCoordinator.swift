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
        self.navigationController = navigationController
        let taskDetailViewController = TaskDetailViewController(task: task)
        taskDetailViewController.delegate = self
        navigationController.pushViewController(taskDetailViewController, animated: true)
    }
    
    func startFlow(in viewController: UIViewController) {
    }
    
}

extension TaskDetailCoordinator: TaskDetailViewControllerDelegate {
    
    /// HomeVC ← TaskDetailVC
    func taskDetailVCDismiss(task: Task) {
        let taskManager = TaskManager()
        taskManager.updateTask(task: task)
    }
    
    /// HomeVC ← TaskDetailVC
    func taskDetailVCDeleteTask(task: Task) {
        let taskManager = TaskManager()
        taskManager.updateTask(task: task)
        navigationController?.popViewController(animated: true)
    }
    
}
