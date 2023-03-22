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
    }
    
    func startFlow(in viewController: UIViewController) {
        previousViewController = viewController
        let characterViewController = CharacterViewController()
        characterViewController.delegate = self
        if #available(iOS 13.0, *) {
            characterViewController.isModalInPresentation = true
        }
        previousViewController!.present(characterViewController, animated: true)
    }
    
}

extension CharacterCoordinator: CharacterViewControllerDelegate {
    
    /// SettingVC ← CharacterVC
    func characterVCSettingDidTap(_ viewController: UIViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    /// SettingVC ← CharacterVC
    func characterVCCancelDidTap(_ viewController: UIViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
}
