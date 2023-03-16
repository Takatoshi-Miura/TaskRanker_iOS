//
//  PageViewModel.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2023/03/16.
//

import UIKit

class PageViewModel {
    
    // MARK: - Variable
    
    var controllers: [UIViewController] = []
    var pageControl: UIPageControl!
    
    // MARK: - Initializer
    
    init() {
        initTutorialView()
        initPageControl()
    }
    
    /// チュートリアル画面の初期化
    private func initTutorialView() {
        for helpItem in HelpItem.allCases {
            let tutorialVC = TutorialViewController(helpItem: helpItem)
            controllers.append(tutorialVC)
        }
    }
    
    /// PageControlの初期化
    private func initPageControl() {
        pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 60, width: UIScreen.main.bounds.width,height: 60))
        pageControl.numberOfPages = controllers.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.isUserInteractionEnabled = false
    }
    
    // MARK: - DataSource
    
    /// 次のページを取得
    /// - Parameters:
    ///   - viewController: ViewController
    ///   - isAfter: 進むフラグ
    /// - Returns: ViewController
    func getNextPage(viewController: UIViewController, isAfter: Bool) -> UIViewController? {
        if isAfter {
            if let index = controllers.firstIndex(of: viewController), index < controllers.count - 1 {
                return controllers[index + 1]
            }
        } else {
            if let index = controllers.firstIndex(of: viewController), index > 0 {
                return controllers[index - 1]
            }
        }
        return nil
    }
    
    /// PageControlのページ切り替え
    /// - Parameter pageViewController: UIPageViewController
    func changePage(pageViewController: UIPageViewController) {
        let currentPage = pageViewController.viewControllers![0]
        pageControl.currentPage = controllers.firstIndex(of: currentPage)!
    }
    
}
