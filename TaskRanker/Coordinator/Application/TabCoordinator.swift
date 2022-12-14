//
//  TabCoordinator.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2022/12/14.
//

import UIKit

class TabCoordinator: Coordinator {
    
    var tabBarController: UITabBarController?
    
    func startFlow(in window: UIWindow?) {
        let pages: [TabBarPage] = [.list, .map].sorted(by: { $0.order < $1.order })
        let controllers: [UINavigationController] = pages.map({ getTabController($0) })
        initTabBarController(withTabControllers: controllers)
        window?.change(rootViewController: tabBarController!, WithAnimation: true)
    }
    
    func startFlow(in navigationController: UINavigationController) {
    }
    
    func startFlow(in viewController: UIViewController) {
    }
    
    /// TabBarControllerに含まれるViewControllerを取得
    /// - Parameter page: ページ番号
    /// - Returns: ViewController(NavigationController配下)
    private func getTabController(_ page: TabBarPage) -> UINavigationController {
        let navController = createNavigationController()
        navController.tabBarItem = UITabBarItem.init(title: page.title, image: page.image, tag: page.order)
        
        switch page {
        case .list:
            let homeCoordinator = HomeCoordinator()
            homeCoordinator.startFlow(in: navController)
        case .map:
            let mapCoordinator = MapCoordinator()
            mapCoordinator.startFlow(in: navController)
        }
        
        return navController
    }
    
    /// TabBarControllerの初期設定
    /// - Parameter withTabControllers: TabBarに含めるViewController
    private func initTabBarController(withTabControllers tabControllers: [UIViewController]) {
        tabBarController = UITabBarController.init()
        tabBarController!.setViewControllers(tabControllers, animated: true)
        tabBarController!.selectedIndex = TabBarPage.list.order
        tabBarController!.tabBar.isTranslucent = false
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .systemBackground
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
}
