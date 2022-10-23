//
//  HomeViewController.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2022/09/10.
//

import UIKit

protocol HomeViewControllerDelegate: AnyObject {
    // 設定ボタンタップ時
    func homeVCSettingButtonDidTap(_ viewController: UIViewController)
    // フィルタボタンタップ時
    func homeVCFilterButtonDidTap(_ viewController: UIViewController)
    // 追加ボタンタップ時
    func homeVCAddButtonDidTap(_ viewController: UIViewController)
    // infoボタンタップ時
    func homeVCInfoButtonDidTap(_ viewController: UIViewController, task: Task)
}

class HomeViewController: UIViewController {
    
    // MARK: - UI,Variable
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var taskListView: UIView!
    private var isFilter: Bool = false
    private var taskListVC_A = TaskListViewController(segmentType: SegmentType.A)
    private var taskListVC_B = TaskListViewController(segmentType: SegmentType.B)
    private var taskListVC_C = TaskListViewController(segmentType: SegmentType.C)
    private var taskListVC_D = TaskListViewController(segmentType: SegmentType.D)
    var delegate: HomeViewControllerDelegate?

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigation()
        initTaskListView()
        addRightSwipeGesture()
        addLeftSwipeGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Task編集画面から戻る時に更新
        reloadTaskList()
    }
    
    /// NavigationController初期化
    private func initNavigation() {
        // 設定メニュー
        let menuButton = UIBarButtonItem(image: UIImage(systemName: "gear"),
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
    
    /// TaskListView初期化
    private func initTaskListView() {
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        
        taskListVC_A.delegate = self
        taskListVC_B.delegate = self
        taskListVC_C.delegate = self
        taskListVC_D.delegate = self
        
        taskListVC_A.view.frame = CGRect(origin: .zero, size: taskListView.bounds.size)
        taskListVC_B.view.frame = CGRect(origin: .zero, size: taskListView.bounds.size)
        taskListVC_C.view.frame = CGRect(origin: .zero, size: taskListView.bounds.size)
        taskListVC_D.view.frame = CGRect(origin: .zero, size: taskListView.bounds.size)
        
        self.taskListView.addSubview(taskListVC_D.view)
        self.taskListView.addSubview(taskListVC_C.view)
        self.taskListView.addSubview(taskListVC_B.view)
        self.taskListView.addSubview(taskListVC_A.view)
        
        selectSegment(number: SegmentType.A.rawValue)
    }
    
    /// TaskListをリロード
    func reloadTaskList() {
        taskListVC_A.refreshData()
        taskListVC_B.refreshData()
        taskListVC_C.refreshData()
        taskListVC_D.refreshData()
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
        delegate?.homeVCSettingButtonDidTap(self)
    }
    
    /// フィルタメニュー
    @objc func openFilterMenu(_ sender: UIBarButtonItem) {
        delegate?.homeVCFilterButtonDidTap(self)
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
        delegate?.homeVCAddButtonDidTap(self)
    }
    
    /// タスクを挿入
    /// - Parameters:
    ///   - task: 挿入する課題
    func insertTask(task: Task) {
        selectSegment(number: task.type.rawValue)
        
        switch SegmentType.allCases[task.type.rawValue] {
        case .A:
            taskListVC_A.insertTask(task: task)
        case .B:
            taskListVC_B.insertTask(task: task)
        case .C:
            taskListVC_C.insertTask(task: task)
        case .D:
            taskListVC_D.insertTask(task: task)
        }
    }
    
}

extension HomeViewController: TaskListViewControllerDelegate {
    
    /// infoボタンタップ時
    func taskListVCInfoButtonDidTap(_ viewController: UIViewController, task: Task) {
        delegate?.homeVCInfoButtonDidTap(self, task: task)
    }
    
}
