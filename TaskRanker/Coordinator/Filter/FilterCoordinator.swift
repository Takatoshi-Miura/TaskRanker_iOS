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
        let filterViewController = FilterViewController(filterArray: nil)
        filterViewController.delegate = self
        navigationController!.pushViewController(filterViewController, animated: true)
        previousViewController!.present(navigationController!, animated: true)
    }
    
    func startFlow(in viewController: UIViewController, filterArray: [Bool]) {
        previousViewController = viewController
        navigationController = createNavigationController()
        let filterViewController = FilterViewController(filterArray: filterArray)
        filterViewController.delegate = self
        navigationController!.pushViewController(filterViewController, animated: true)
        previousViewController!.present(navigationController!, animated: true)
    }
    
}

extension FilterCoordinator: FilterViewControllerDelegate {
    
    /// HomeVC ← FilterVC
    func filterVCDismiss(_ viewController: UIViewController, filterArray: [Bool]) {
        (previousViewController as! HomeViewController).applyFilter(filterArray: filterArray)
        viewController.dismiss(animated: true, completion: nil)
    }
    
}
