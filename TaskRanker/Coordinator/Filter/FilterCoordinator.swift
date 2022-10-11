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
        let filterViewController = FilterViewController()
        filterViewController.delegate = self
        previousViewController!.present(filterViewController, animated: true)
    }
    
}

extension FilterCoordinator: FilterViewControllerDelegate {
    
    /// HomeVC ← FilterVC
    func filterVCDismiss(_ viewController: UIViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
}
