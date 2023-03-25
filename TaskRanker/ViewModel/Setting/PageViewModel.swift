//
//  PageViewModel.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2023/03/16.
//

import UIKit

enum PageViewMode: Int {
    case Help
    case Character
}

class PageViewModel: NSObject {
    
    // MARK: - Variable
    
    var controllers: [UIViewController]!
    var pageControl: UIPageControl!
    private var pageViewMode: PageViewMode
    
    // MARK: - Initializer
    
    init(pageViewMode: PageViewMode) {
        self.pageViewMode = pageViewMode
        super.init()
        initControllers()
        initPageControl()
    }
    
    /// Controllersの初期化
    private func initControllers() {
        controllers = []
        switch pageViewMode {
        case .Help:
            for helpItem in HelpItem.allCases {
                let tutorialVC = TutorialViewController(helpItem: helpItem)
                controllers.append(tutorialVC)
            }
        case .Character:
            // TODO: 申請時に設定を変える
            for character in Character.allCases {
                let characterVC = CharacterViewController(character: character)
                controllers.append(characterVC)
            }
        }
    }
    
    /// PageControlの初期化
    private func initPageControl() {
        pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 90, width: UIScreen.main.bounds.width, height: 60))
        pageControl.numberOfPages = controllers.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.isUserInteractionEnabled = false
    }
    
    /// タイトルを取得
    /// - Returns: タイトル文字列
    func getTitle() -> String {
        switch pageViewMode {
        case .Help:
            return TITLE_HOW_TO_USE_THIS_APP
        case .Character:
            return TITLE_CHARACTER_SETTING
        }
    }
    
}

extension PageViewModel: UIPageViewControllerDataSource {
    
    /// ページ数
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return controllers.count
    }
   
    /// 左にスワイプ（進む）
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = controllers.firstIndex(of: viewController), index < controllers.count - 1 {
            return controllers[index + 1]
        }
        return nil
    }

    /// 右にスワイプ （戻る）
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = controllers.firstIndex(of: viewController), index > 0 {
            return controllers[index - 1]
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
