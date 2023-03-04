//
//  PageViewController.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2022/10/11.
//

import UIKit

protocol PageViewControllerDelegate: AnyObject {
    // キャンセルタップ時の処理
    func pageVCCancelDidTap(_ viewController: UIViewController)
}

class PageViewController: UIPageViewController {
    
    // MARK: - UI,Variable
    
    private var controllers: [UIViewController] = []
    private var pageControl: UIPageControl!
    var pageVCDelegate: PageViewControllerDelegate?
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTutorialView()
        addPageView()
        addPageControl()
        addCancelButton()
    }
    
    // MARK: - Viewer
    
    /// チュートリアル画面を追加
    private func addTutorialView() {
        for helpItem in HelpItem.allCases {
            let tutorialVC = TutorialViewController(helpItem: helpItem)
            controllers.append(tutorialVC)
        }
    }
    
    /// PageViewControllerを追加
    private func addPageView() {
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.setViewControllers([controllers[0]], direction: .forward, animated: true, completion: nil)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        self.addChild(pageViewController)
        self.view.addSubview(pageViewController.view!)
    }
    
    /// PageControlを追加
    private func addPageControl() {
        pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 60, width: UIScreen.main.bounds.width,height: 60))
        pageControl.numberOfPages = controllers.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.isUserInteractionEnabled = false
        self.view.addSubview(pageControl)
    }
    
    /// キャンセルボタンを追加
    private func addCancelButton() {
        let button = UIButton()
        button.addTarget(self, action: #selector(tapCloseButton(_:)), for: UIControl.Event.touchUpInside)
        button.setTitle(TITLE_CANCEL, for: UIControl.State.normal)
        button.setTitleColor(UIColor.white, for: UIControl.State.normal)
        button.frame = CGRect(x: UIScreen.main.bounds.maxX - 120, y: UIScreen.main.bounds.maxY - 60, width: 120, height: 60)
        self.view.addSubview(button)
    }
    
    // MARK: - Action
    
    /// キャンセルボタンの処理
    @objc func tapCloseButton(_ sender: UIButton) {
        pageVCDelegate?.pageVCCancelDidTap(self)
    }
    
}

extension PageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    /// ページ数
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return controllers.count
    }
   
    /// 左にスワイプ（進む）
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = controllers.firstIndex(of: viewController), index < controllers.count - 1 {
            return controllers[index + 1]
        } else {
            return nil
        }
    }

    /// 右にスワイプ （戻る）
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = controllers.firstIndex(of: viewController), index > 0 {
            return controllers[index - 1]
        } else {
            return nil
        }
    }
    
    /// アニメーション終了後処理
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let currentPage = pageViewController.viewControllers![0]
        pageControl.currentPage = controllers.firstIndex(of: currentPage)!
    }
    
}
