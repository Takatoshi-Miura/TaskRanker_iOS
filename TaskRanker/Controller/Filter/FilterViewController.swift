//
//  FilterViewController.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2022/10/11.
//

import UIKit

protocol FilterViewControllerDelegate: AnyObject {
    /// モーダルを閉じる
    func filterVCDismiss(_ viewController: UIViewController)
}

class FilterViewController: UIViewController {
    
    // MARK: - UI,Variable
    
    var delegate: FilterViewControllerDelegate?

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    /// 画面初期化
    private func initView() {
        
    }

}
