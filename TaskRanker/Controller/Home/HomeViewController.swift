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
    private var isFilter: Bool = false
    private var taskListVC_A = TaskListViewController()
    private var taskListVC_B = TaskListViewController()
    private var taskListVC_C = TaskListViewController()
    private var taskListVC_D = TaskListViewController()

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigation()
        initSegmentedControl()
        addRightSwipeGesture()
        addLeftSwipeGesture()
    }
    
    /// NavigationController初期化
    private func initNavigation() {
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
    
    /// SegmentedControl初期化
    private func initSegmentedControl() {
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        
        taskListVC_A.view.frame = CGRect(origin: .zero, size: taskListView.bounds.size)
        taskListVC_B.view.frame = CGRect(origin: .zero, size: taskListView.bounds.size)
        taskListVC_C.view.frame = CGRect(origin: .zero, size: taskListView.bounds.size)
        taskListVC_D.view.frame = CGRect(origin: .zero, size: taskListView.bounds.size)
        
        taskListVC_A.segmentType = SegmentType.A
        taskListVC_B.segmentType = SegmentType.B
        taskListVC_C.segmentType = SegmentType.C
        taskListVC_D.segmentType = SegmentType.D
        
        self.taskListView.addSubview(taskListVC_D.view)
        self.taskListView.addSubview(taskListVC_C.view)
        self.taskListView.addSubview(taskListVC_B.view)
        self.taskListView.addSubview(taskListVC_A.view)
        
        selectSegment(number: SegmentType.A.rawValue)
    }
    
    /// 右スワイプでABCD切り替え
    private func addRightSwipeGesture() {
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(rightSwipeTaskList))
        rightSwipe.direction = .right
        self.taskListView.addGestureRecognizer(rightSwipe)
    }
    
    /// 左スワイプでABCD切り替え
    private func addLeftSwipeGesture() {
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipeTaskList))
        leftSwipe.direction = .left
        self.taskListView.addGestureRecognizer(leftSwipe)
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
    
    /// segmentedControl選択
    @IBAction func selectSegmentedControl(_ sender: UISegmentedControl) {
        selectSegment(number: sender.selectedSegmentIndex)
    }
    
    /// 右スワイプ
    @objc func rightSwipeTaskList() {
        var selectNo = segmentedControl.selectedSegmentIndex - 1
        if selectNo < SegmentType.A.rawValue {
            selectNo = SegmentType.A.rawValue
        }
        selectSegment(number: selectNo)
    }
    
    /// 左スワイプ
    @objc func leftSwipeTaskList() {
        var selectNo = segmentedControl.selectedSegmentIndex + 1
        if selectNo > SegmentType.D.rawValue {
            selectNo = SegmentType.D.rawValue
        }
        selectSegment(number: selectNo)
    }
    
    /// SegmentControl選択時の処理
    private func selectSegment(number: Int) {
        segmentedControl.selectedSegmentIndex = number
        
        setNavigationTitle(segmentType: SegmentType.allCases[number])
        
        switch SegmentType.allCases[number] {
        case .A:
            self.taskListView.bringSubviewToFront(taskListVC_A.view)
        case .B:
            self.taskListView.bringSubviewToFront(taskListVC_B.view)
        case .C:
            self.taskListView.bringSubviewToFront(taskListVC_C.view)
        case .D:
            self.taskListView.bringSubviewToFront(taskListVC_D.view)
        }
    }
    
    /// タイトル文字列の設定
    /// - Parameters:
    ///    - segmentType: segmentedControlの選択番号
    private func setNavigationTitle(segmentType: SegmentType) {
        let titleLabel = UILabel()
        titleLabel.text = segmentType.title
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.textColor = .label
        
        let attrText = NSMutableAttributedString(string: titleLabel.text!)
        attrText.addAttribute(.foregroundColor, value: segmentType.importanceColor, range: NSMakeRange(4, 1))
        attrText.addAttribute(.foregroundColor, value: segmentType.urgencyColor, range: NSMakeRange(11, 1))
        titleLabel.attributedText = attrText
        
        self.navigationItem.titleView = titleLabel
    }
    
    /// タスク追加
    @IBAction func tapAddButton(_ sender: Any) {
    }
    

}
