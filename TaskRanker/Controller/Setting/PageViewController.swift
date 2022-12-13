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
        initPageView()
    }
    
    /// PageView初期化
    private func initPageView() {
        // チュートリアル画面を追加
        // TODO: リファクタリング、文言、画像修正
        let titleArray = ["TaskRankerとは","タスクの作成","タスクの分類","タスク管理","フィルタ","タスクの完了"]
        
        let detailArray = ["タスクの優先順位付けを行ってくれるタスク管理アプリです。\nタスクの重要度と緊急度から優先順位を判定し、タスクを分類します。",
                           "＋ボタンからタスクを作成できます。\n重要度と緊急度を10段階で設定できます。\n期限日を設定すると期限日の　日前に自動的に緊急度を引き上げます。",
                           "重要度と緊急度によって、4つのタイプに分類します。\nA：重要度6〜10, 緊急度6~10\nB：重要度6〜10, 緊急度1~5\nC：重要度1〜5, 緊急度6~10\nD：重要度1〜5, 緊急度1~5",
                           "作成したタスクは一覧で管理できます。\nタスクは重要度が高い順に表示されます。",
                           "一覧に表示するタスクは、フィルタからカラーで絞り込むことができます。",
                           "タスクの◯をタップすると完了にできます。\n完了したタスクは完了済みタスク画面で確認できます。"]
        
        let imageArray = [UIImage(systemName: "gear"),
                          UIImage(systemName: "gear"),
                          UIImage(systemName: "gear"),
                          UIImage(systemName: "gear"),
                          UIImage(systemName: "gear"),
                          UIImage(systemName: "gear")]
        
        for index in 0...titleArray.count - 1 {
            let tutorialVC = TutorialViewController()
            tutorialVC.initView(title: titleArray[index], detail: detailArray[index], image: imageArray[index]!)
            self.controllers.append(tutorialVC)
        }
        
        // pageViewController追加
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.setViewControllers([self.controllers[0]], direction: .forward, animated: true, completion: nil)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        self.addChild(pageViewController)
        self.view.addSubview(pageViewController.view!)
        
        // pageControl追加
        pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 60, width: UIScreen.main.bounds.width,height: 60))
        pageControl.numberOfPages = self.controllers.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.isUserInteractionEnabled = false
        self.view.addSubview(self.pageControl)
        
        // キャンセルボタン追加
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
