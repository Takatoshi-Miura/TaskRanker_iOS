//
//  PageCoordinator.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2022/10/11.
//

import UIKit

class PageCoordinator: Coordinator {
    
    var navigationController: UINavigationController?
    var previousViewController: UIViewController?
    
    func startFlow(in window: UIWindow?) {
    }
    
    func startFlow(in navigationController: UINavigationController) {
        self.navigationController = navigationController
        let pageViewController = PageViewController()
        self.navigationController?.pushViewController(pageViewController, animated: true)
    }
    
    func startFlow(in viewController: UIViewController) {
    }
    
}
