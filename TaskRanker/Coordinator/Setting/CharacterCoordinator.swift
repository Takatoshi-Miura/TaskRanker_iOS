//
//  CharacterCoordinator.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2023/03/22.
//

import UIKit

class CharacterCoordinator: Coordinator {
    
    var navigationController: UINavigationController?
    var previousViewController: UIViewController?
    
    func startFlow(in window: UIWindow?) {
    }
    
    func startFlow(in navigationController: UINavigationController) {
        self.navigationController = navigationController
        let characterViewController = CharacterViewController()
        characterViewController.delegate = self
        self.navigationController?.pushViewController(characterViewController, animated: true)
    }
    
    func startFlow(in viewController: UIViewController) {
    }
    
}

extension CharacterCoordinator: CharacterViewControllerDelegate {
    
    /// SettingVC ← CharacterVC
    func characterVCSettingDidTap() {
        navigationController?.popViewController(animated: true)
    }
    
}
