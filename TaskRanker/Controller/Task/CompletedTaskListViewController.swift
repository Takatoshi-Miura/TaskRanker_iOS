//
//  CompletedTaskListViewController.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2022/10/24.
//

import UIKit

protocol CompletedTaskListViewControllerDelegate: AnyObject {
    /// モーダルを閉じる
    func CompletedTaskListVCDismiss(_ viewController: UIViewController)
}

class CompletedTaskListViewController: UIViewController {

    // MARK: - UI,Variable
    
    var delegate: CompletedTaskListViewControllerDelegate?

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    /// 画面初期化
    private func initView() {
        
    }

}
