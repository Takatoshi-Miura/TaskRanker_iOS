//
//  TaskViewCoordinator.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2022/10/23.
//

import UIKit

class TaskViewCoordinator: Coordinator {
    
    var navigationController: UINavigationController?
    var previousViewController: UIViewController?
    
    func startFlow(in window: UIWindow?) {
    }
    
    func startFlow(in navigationController: UINavigationController) {
    }
    
    func startFlow(in navigationController: UINavigationController, task: Task) {
        // タスク詳細画面
        self.navigationController = navigationController
        let taskViewController = TaskViewController(task: task)
        taskViewController.delegate = self
        navigationController.pushViewController(taskViewController, animated: true)
    }
    
    func startFlow(in viewController: UIViewController) {
        // タスク新規作成画面
        previousViewController = viewController
        navigationController = createNavigationController()
        let taskViewController = TaskViewController(task: nil)
        taskViewController.delegate = self
        if #available(iOS 13.0, *) {
            taskViewController.isModalInPresentation = true
        }
        navigationController!.pushViewController(taskViewController, animated: true)
        previousViewController!.present(navigationController!, animated: true)
    }
    
}

extension TaskViewCoordinator: TaskViewControllerDelegate {
    
    /// HomeVC ← AddTaskVC
    func taskVCDismiss(_ viewController: UIViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    /// HomeVC ← AddTaskVC
    func taskVCAddTask(_ viewController: UIViewController, task: Task) {
        viewController.dismiss(animated: true, completion: nil)
        (previousViewController! as! HomeViewController).insertTask(task: task)
    }
    
    /// HomeVC ← TaskDetailVC
    func taskVCDismiss(task: Task) {
        let taskManager = TaskManager()
        taskManager.updateTask(task: task)
    }
    
    /// HomeVC ← TaskDetailVC
    func taskVCDeleteTask(task: Task) {
        let taskManager = TaskManager()
        taskManager.updateTask(task: task)
        navigationController?.popViewController(animated: true)
    }
    
}
