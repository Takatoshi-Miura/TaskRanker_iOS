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
    }
    
    func startFlow(in navigationController: UINavigationController) {
        self.navigationController = navigationController
        let homeViewController = HomeViewController()
        homeViewController.delegate = self
        navigationController.pushViewController(homeViewController, animated: true)
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
    func homeVCFilterButtonDidTap(_ viewController: UIViewController, filterArray: [Bool]) {
        let filterCoordinator = FilterCoordinator()
        filterCoordinator.startFlow(in: viewController, filterArray: filterArray)
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
    
    /// HomeVC → CharacterVC
    func homeVCCharacterDidTap(_ viewController: UIViewController) {
        let pageCoordinator = PageCoordinator()
        pageCoordinator.startFlow(in: viewController, pageViewMode: PageViewMode.Character)
    }
    
}
