//
//  HomeCoordinator.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2022/09/10.
//

import UIKit

class HomeCoordinator: Coordinator {
    
    var navigationController: UINavigationController?
    
    func startFlow(in window: UIWindow?) {
        self.navigationController = createNavigationController()
        let homeViewController = HomeViewController()
        homeViewController.delegate = self
        navigationController!.pushViewController(homeViewController, animated: true)
        window?.change(rootViewController: navigationController!, WithAnimation: true)
    }
    
    func startFlow(in navigationController: UINavigationController) {
    }
    
    func startFlow(in viewController: UIViewController) {
    }
    
}

extension HomeCoordinator: HomeViewControllerDelegate {
    
    /// HomeVC → SettingVC
    func homeVCSettingButtonDidTap(_ viewController: UIViewController) {
        let settingCoordinator = SettingCoordinator()
        settingCoordinator.startFlow(in: viewController)
    }
    
    /// HomeVC → completedTaskListVC
    func homeVCCompletedTaskListButtonDidTap(_ viewController: UIViewController) {
        let comletedTaskListCoordinator = ComletedTaskListCoordinator()
        comletedTaskListCoordinator.startFlow(in: viewController)
    }
    
    /// HomeVC → FilterVC
    func homeVCFilterButtonDidTap(_ viewController: UIViewController) {
        let filterCoordinator = FilterCoordinator()
        filterCoordinator.startFlow(in: viewController)
    }
    
    /// HomeVC → AddTaskVC
    func homeVCAddButtonDidTap(_ viewController: UIViewController) {
        let taskDetailCoordinator = TaskViewCoordinator()
        taskDetailCoordinator.startFlow(in: viewController)
    }
    
    /// HomeVC → TaskDetailVC
    func homeVCTaskDidTap(_ viewController: UIViewController, task: Task) {
        let taskDetailCoordinator = TaskViewCoordinator()
        taskDetailCoordinator.startFlow(in: navigationController!, task: task)
    }
    
}
