//
//  Definition+Navigation.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2022/10/27.
//

import UIKit

/// NavigationController生成
func createNavigationController() -> UINavigationController {
    let navController = UINavigationController()
    navController.setNavigationBarHidden(false, animated: false)
    if #available(iOS 15.0, *) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        appearance.backgroundEffect = UIBlurEffect(style: .light)
        navController.navigationBar.standardAppearance = appearance
        navController.navigationBar.scrollEdgeAppearance = appearance
    }
    return navController
}
