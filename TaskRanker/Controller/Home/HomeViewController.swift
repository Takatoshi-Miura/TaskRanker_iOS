//
//  HomeViewController.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2022/09/10.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - UI,Variable
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var taskListView: UIView!
    @IBOutlet weak var completedTaskButton: UIButton!
    private var isFilter: Bool = false

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    /// 画面初期化
    private func initView() {
        self.title = ""
        
        // 設定メニュー
        let isDarkMode = UITraitCollection.current.userInterfaceStyle == .dark
        let menuImage = isDarkMode ? UIImage(named: "humburger_menu_white")! : UIImage(named: "humburger_menu_black")!
        let menuButton = UIBarButtonItem(image: menuImage.withRenderingMode(.alwaysOriginal),
                                         style: .plain,
                                         target: self,
                                         action: #selector(openHumburgerMenu(_:)))
        
        // フィルタ
        let filterImage = isFilter ? UIImage(named: "icon_filter_fill")! : UIImage(named: "icon_filter_empty")!
        let filterButton = UIBarButtonItem(image: filterImage,
                                           style: .done,
                                           target: self,
                                           action: #selector(openFilterMenu))
        
        navigationItem.leftBarButtonItems = [menuButton]
        navigationItem.rightBarButtonItems = [filterButton]
    }
    
    // MARK: - Action
    
    /// 設定メニュー
    @objc func openHumburgerMenu(_ sender: UIBarButtonItem) {
//        delegate?.taskVCSettingDidTap(self)
    }
    
    /// 設定メニュー
    @objc func openFilterMenu(_ sender: UIBarButtonItem) {
//        delegate?.taskVCSettingDidTap(self)
    }
    
    /// タスク追加
    @IBAction func tapAddButton(_ sender: Any) {
    }
    

}
