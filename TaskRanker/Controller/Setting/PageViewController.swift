//
//  PageViewController.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2022/10/11.
//

import UIKit

class PageViewController: UIPageViewController {
    
    // MARK: - Variable
    
    private var pageViewModel = PageViewModel()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addPageView()
        addPageControl()
    }
    
    // MARK: - Viewer
    
    /// PageViewControllerを追加
    private func addPageView() {
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.setViewControllers([pageViewModel.controllers[0]], direction: .forward, animated: true, completion: nil)
        pageViewController.dataSource = pageViewModel
        pageViewController.delegate = self
        self.addChild(pageViewController)
        self.view.addSubview(pageViewController.view!)
    }
    
    /// PageControlを追加
    private func addPageControl() {
        self.view.addSubview(pageViewModel.pageControl)
    }
    
}

extension PageViewController: UIPageViewControllerDelegate {
    
    /// アニメーション終了後処理
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        pageViewModel.changePage(pageViewController: pageViewController)
    }
    
}
