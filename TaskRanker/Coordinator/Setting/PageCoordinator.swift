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
    }
    
    func startFlow(in navigationController: UINavigationController, pageViewMode: PageViewMode) {
        self.navigationController = navigationController
        let pageViewController = PageViewController(pageViewMode: pageViewMode)
        self.navigationController?.pushViewController(pageViewController, animated: true)
    }
    
    func startFlow(in viewController: UIViewController) {
    }
    
    func startFlow(in viewController: UIViewController, pageViewMode: PageViewMode) {
        previousViewController = viewController
        navigationController = createNavigationController()
        let pageViewController = PageViewController(pageViewMode: pageViewMode)
        navigationController!.pushViewController(pageViewController, animated: true)
        previousViewController!.present(navigationController!, animated: true)
    }
    
}
