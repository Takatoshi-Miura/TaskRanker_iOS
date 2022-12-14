//
//  MapCoordinator.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2022/12/14.
//

import UIKit

class MapCoordinator: Coordinator {
    
    var navigationController: UINavigationController?
    
    func startFlow(in window: UIWindow?) {
    }
    
    func startFlow(in navigationController: UINavigationController) {
        self.navigationController = navigationController
        let mapViewController = MapViewController()
//        homeViewController.delegate = self
        navigationController.pushViewController(mapViewController, animated: true)
    }
    
    func startFlow(in viewController: UIViewController) {
    }
    
}
