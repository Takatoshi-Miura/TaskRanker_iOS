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
        mapViewController.delegate = self
        navigationController.pushViewController(mapViewController, animated: true)
    }
    
    func startFlow(in viewController: UIViewController) {
    }
    
}

extension MapCoordinator: MapViewControllerDelegate {
    
    /// MapVC → TaskDetail
    func mapVCTaskDidTap(_ viewController: UIViewController, task: Task) {
        let taskDetailCoordinator = TaskViewCoordinator()
        taskDetailCoordinator.startFlow(in: navigationController!, task: task)
    }
    
    /// MapVC → CharacterVC
    func mapVCCharacterDidTap(_ viewController: UIViewController) {
        let pageCoordinator = PageCoordinator()
        pageCoordinator.startFlow(in: viewController, pageViewMode: PageViewMode.Character)
    }
    
}
