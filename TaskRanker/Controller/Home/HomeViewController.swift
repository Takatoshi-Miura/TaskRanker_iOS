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
    // 完了タスクボタンタップ時
    func homeVCCompletedTaskListButtonDidTap(_ viewController: UIViewController)
    // フィルタボタンタップ時
    func homeVCFilterButtonDidTap(_ viewController: UIViewController)
    // フィルタボタンタップ時(既にフィルタが適用されている場合)
    func homeVCFilterButtonDidTap(_ viewController: UIViewController, filterArray: [Bool])
    // 追加ボタンタップ時
    func homeVCAddButtonDidTap(_ viewController: UIViewController)
    // Taskタップ時
    func homeVCTaskDidTap(_ viewController: UIViewController, task: Task)
}

class HomeViewController: UIViewController {
    
    // MARK: - UI,Variable
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var taskListView: UIView!
    private var isFilter: Bool = false
    private var filterArray: [Bool]?
    private var taskListVC_A = TaskListViewController(segmentType: SegmentType.A)
    private var taskListVC_B = TaskListViewController(segmentType: SegmentType.B)
    private var taskListVC_C = TaskListViewController(segmentType: SegmentType.C)
    private var taskListVC_D = TaskListViewController(segmentType: SegmentType.D)
    private var selectedTask: Task?
    private var selectedIndex: IndexPath?
    var delegate: HomeViewControllerDelegate?

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigation()
        initTaskListView()
        addRightSwipeGesture()
        addLeftSwipeGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if selectedTask == nil || selectedIndex == nil {
            return
        }
        switch SegmentType.allCases[selectedTask!.type.rawValue] {
        case .A:
            taskListVC_A.updateTask(indexPath: selectedIndex!)
        case .B:
            taskListVC_B.updateTask(indexPath: selectedIndex!)
        case .C:
            taskListVC_C.updateTask(indexPath: selectedIndex!)
        case .D:
            taskListVC_D.updateTask(indexPath: selectedIndex!)
        }
        selectedTask = nil
        selectedIndex = nil
    }
    
    /// NavigationController初期化
    private func initNavigation() {
        // 設定メニュー
        let menuButton = UIBarButtonItem(image: UIImage(systemName: "gear"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(openHumburgerMenu(_:)))
        
        // 完了タスク
        let completeButton = UIBarButtonItem(image: UIImage(systemName: "checkmark.circle"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(openCompletedTaskList(_:)))
        
        // フィルタ
        let filterImage = isFilter ? UIImage(named: "icon_filter_fill")! : UIImage(named: "icon_filter_empty")!
        let filterButton = UIBarButtonItem(image: filterImage,
                                           style: .done,
                                           target: self,
                                           action: #selector(openFilterMenu))
        
        navigationItem.leftBarButtonItems = [menuButton]
        navigationItem.rightBarButtonItems = [filterButton, completeButton]
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
    
    /// 完了タスク
    @objc func openCompletedTaskList(_ sender: UIBarButtonItem) {
        delegate?.homeVCCompletedTaskListButtonDidTap(self)
    }
    
    /// フィルタメニュー
    @objc func openFilterMenu(_ sender: UIBarButtonItem) {
        if isFilter {
            delegate?.homeVCFilterButtonDidTap(self, filterArray: filterArray!)
        } else {
            delegate?.homeVCFilterButtonDidTap(self)
        }
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
    
    /// タスクを挿入(新規追加、未完了に戻す)
    /// - Parameters:
    ///   - task: 挿入する課題
    func insertTask(task: Task) {
        // TODO: フィルタの扱いをどうするか
//        applyFilter(filterArray: [true])
        
        // 挿入するタスクのタイプへ移動
        selectSegment(number: task.type.rawValue)
        
        // タスクを挿入
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            switch SegmentType.allCases[task.type.rawValue] {
            case .A:
                self.taskListVC_A.insertTask(task: task)
            case .B:
                self.taskListVC_B.insertTask(task: task)
            case .C:
                self.taskListVC_C.insertTask(task: task)
            case .D:
                self.taskListVC_D.insertTask(task: task)
            }
        }
    }
    
    /// フィルタを適用
    /// - Parameters:
    ///   - filterArray: チェック配列
    func applyFilter(filterArray: [Bool]) {
        isFilter = (filterArray.firstIndex(of: false) != nil) ? true : false
        if isFilter {
            self.filterArray = filterArray
            applyFilterTaskList()
        } else {
            self.filterArray = nil
            reloadTaskList()
        }
        initNavigation()
    }
    
    /// TaskListをリロード
    private func reloadTaskList() {
        taskListVC_A.refreshData()
        taskListVC_B.refreshData()
        taskListVC_C.refreshData()
        taskListVC_D.refreshData()
    }
    
    /// TaskListにフィルタを適用
    private func applyFilterTaskList() {
        taskListVC_A.applyFilter(filterArray: filterArray!)
        taskListVC_B.applyFilter(filterArray: filterArray!)
        taskListVC_C.applyFilter(filterArray: filterArray!)
        taskListVC_D.applyFilter(filterArray: filterArray!)
    }
    
}

extension HomeViewController: TaskListViewControllerDelegate {
    
    /// Taskタップ時
    func taskListVCTaskDidTap(_ viewController: UIViewController, task: Task, indexPath: IndexPath) {
        selectedTask = task
        selectedIndex = indexPath
        delegate?.homeVCTaskDidTap(self, task: task)
    }
    
}
