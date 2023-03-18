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
    
    // MARK: - Variable
    
    private var pageViewModel = PageViewModel()
    var pageViewDelegate: PageViewControllerDelegate?
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addPageView()
        addPageControl()
        addCancelButton()
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
        pageViewDelegate?.pageVCCancelDidTap(self)
    }
    
}

extension PageViewController: UIPageViewControllerDelegate {
    
    /// アニメーション終了後処理
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        pageViewModel.changePage(pageViewController: pageViewController)
    }
    
}
