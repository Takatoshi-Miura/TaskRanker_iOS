//
//  FilterCoordinator.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2022/10/11.
//

import UIKit

class FilterCoordinator: Coordinator {
    
    var navigationController: UINavigationController?
    var previousViewController: UIViewController?
    
    func startFlow(in window: UIWindow?) {
    }
    
    func startFlow(in navigationController: UINavigationController) {
    }
    
    func startFlow(in viewController: UIViewController) {
        previousViewController = viewController
        navigationController = createNavigationController()
        let filterViewController = FilterViewController()
        filterViewController.delegate = self
        navigationController!.pushViewController(filterViewController, animated: true)
        previousViewController!.present(navigationController!, animated: true)
    }
    
}

extension FilterCoordinator: FilterViewControllerDelegate {
    
    /// HomeVC ← FilterVC
    func filterVCDismiss(_ viewController: UIViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
}
