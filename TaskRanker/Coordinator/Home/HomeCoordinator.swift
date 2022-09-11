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
    
    /// NavigationController生成
    private func createNavigationController() -> UINavigationController {
        let navController = UINavigationController()
        navController.setNavigationBarHidden(false, animated: false)
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .systemBackground
            appearance.backgroundEffect = UIBlurEffect(style: .light)
            navController.navigationBar.standardAppearance = appearance
            navController.navigationBar.scrollEdgeAppearance = appearance
        }
        return navController
    }
    
}

extension HomeCoordinator: HomeViewControllerDelegate {
    
    /// HomeVC → AddTaskVC
    func homeVCAddButtonDidTap(_ viewController: UIViewController) {
        let addTaskCoordinator = AddTaskCoordinator()
        addTaskCoordinator.startFlow(in: viewController)
    }
    
    
}
