//
//  AppCoordinator.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2022/09/10.
//

import UIKit

class AppCoordinator: Coordinator {
    
    var window: UIWindow?
    var homeCoordinator: HomeCoordinator?
    
    func startFlow(in window: UIWindow?) {
        self.window = window
        homeCoordinator = HomeCoordinator()
        homeCoordinator?.startFlow(in: window)
    }
    
    func startFlow(in navigationController: UINavigationController) {
    }
    
    func startFlow(in viewController: UIViewController) {
    }
    
}

extension UIWindow {
    
    public func change(rootViewController: UIViewController, WithAnimation animation: Bool) {
        self.rootViewController = nil
        self.rootViewController = rootViewController
        rootViewController.view.alpha = animation ? 0 : 1
        makeKeyAndVisible()
        guard animation else { return }
        UIView.animate(withDuration: 0.3) { rootViewController.view.alpha = 1 }
    }
    
}

