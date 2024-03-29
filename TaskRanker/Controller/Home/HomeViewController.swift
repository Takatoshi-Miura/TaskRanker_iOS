//
//  HomeViewController.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2022/09/10.
//

import UIKit
import GoogleMobileAds

protocol HomeViewControllerDelegate: AnyObject {
    /// 設定ボタンタップ時
    func homeVCSettingButtonDidTap(_ viewController: UIViewController)
    /// 完了タスクボタンタップ時
    func homeVCCompletedTaskListButtonDidTap(_ viewController: UIViewController)
    /// フィルタボタンタップ時
    func homeVCFilterButtonDidTap(_ viewController: UIViewController, filterArray: [Bool])
    /// 追加ボタンタップ時
    func homeVCAddButtonDidTap(_ viewController: UIViewController)
    /// Taskタップ時
    func homeVCTaskDidTap(_ viewController: UIViewController, task: Task)
    /// キャラクタータップ時
    func homeVCCharacterDidTap(_ viewController: UIViewController)
}

class HomeViewController: UIViewController {
    
    // MARK: - UI,Variable
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var taskListView: UIView!
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var characterMessageLabel: UILabel!
    @IBOutlet weak var adView: UIView!
    private var adMobView: GADBannerView?
    private var homeViewModel: HomeViewModel
    private var taskListVC_A: TaskListViewController
    private var taskListVC_B: TaskListViewController
    private var taskListVC_C: TaskListViewController
    private var taskListVC_D: TaskListViewController
    private var timer: Timer?
    var delegate: HomeViewControllerDelegate?
    
    // MARK: - Initializer
    
    init() {
        homeViewModel = HomeViewModel()
        taskListVC_A = TaskListViewController(taskType: TaskType.A, filterArray: homeViewModel.getFilterArray())
        taskListVC_B = TaskListViewController(taskType: TaskType.B, filterArray: homeViewModel.getFilterArray())
        taskListVC_C = TaskListViewController(taskType: TaskType.C, filterArray: homeViewModel.getFilterArray())
        taskListVC_D = TaskListViewController(taskType: TaskType.D, filterArray: homeViewModel.getFilterArray())
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigation()
        initTaskListView()
        initCharacterView()
        initGestureRecognizer()
        initNotification()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        showAdMob()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let selectedTask = homeViewModel.getSelectedTask(), let selectedIndex = homeViewModel.getSelectedIndex() {
            updateTaskListView(task: selectedTask, indexPath: selectedIndex)
            startTimer()
        }
        homeViewModel.clearTaskIndex()
    }
    
    /// NavigationController初期化
    private func initNavigation() {
        let menuButton = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(openHumburgerMenu(_:)))
        let completeButton = UIBarButtonItem(image: UIImage(systemName: "checkmark.circle"), style: .plain, target: self, action: #selector(openCompletedTaskList(_:)))
        let filterImage = homeViewModel.isFilter() ? UIImage(named: "icon_filter_fill")! : UIImage(named: "icon_filter_empty")!
        let filterButton = UIBarButtonItem(image: filterImage, style: .done, target: self, action: #selector(openFilterMenu))
        navigationItem.leftBarButtonItems = [menuButton]
        navigationItem.rightBarButtonItems = [filterButton, completeButton]
    }
    
    /// バナー広告を表示
    private func showAdMob() {
        if let adMobView = adMobView {
            adMobView.frame.size = CGSize(width: self.view.frame.width, height: adMobView.frame.height)
            return
        }
        adMobView = GADBannerView()
        adMobView = GADBannerView(adSize: GADAdSizeBanner)
        #if DEBUG
        adMobView!.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        #else
        adMobView!.adUnitID = "ca-app-pub-9630417275930781/6787558566"
        #endif
        adMobView!.rootViewController = self
        adMobView!.load(GADRequest())
        adMobView!.frame.origin = CGPoint(x: 0, y: 0)
        adMobView!.frame.size = CGSize(width: self.view.frame.width, height: 50)
        adView.addSubview(adMobView!)
    }
    
    // MARK: - TaskList
    
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
        
        taskListView.addSubview(taskListVC_A.view)
        taskListView.addSubview(taskListVC_B.view)
        taskListView.addSubview(taskListVC_C.view)
        taskListView.addSubview(taskListVC_D.view)
        
        selectSegment(number: TaskType.A.rawValue)
    }
    
    /// 選択したTaskTypeのViewを最前面に移動
    /// - Parameter type: TaskType
    private func moveFrontTaskListView(type: TaskType) {
        switch type {
        case .A: taskListView.bringSubviewToFront(taskListVC_A.view)
        case .B: taskListView.bringSubviewToFront(taskListVC_B.view)
        case .C: taskListView.bringSubviewToFront(taskListVC_C.view)
        case .D: taskListView.bringSubviewToFront(taskListVC_D.view)
        }
    }
    
    /// フィルタを適用
    private func applyFilterTaskListView() {
        taskListVC_A.applyFilter(filterArray: homeViewModel.getFilterArray())
        taskListVC_B.applyFilter(filterArray: homeViewModel.getFilterArray())
        taskListVC_C.applyFilter(filterArray: homeViewModel.getFilterArray())
        taskListVC_D.applyFilter(filterArray: homeViewModel.getFilterArray())
    }
    
    /// TaskListを同期
    @objc func syncTaskListView() {
        taskListVC_A.syncData()
        taskListVC_B.syncData()
        taskListVC_C.syncData()
        taskListVC_D.syncData()
    }
    
    /// Taskを挿入
    /// - Parameter task: Task
    private func insertTaskListView(task: Task) {
        switch task.type {
        case .A: taskListVC_A.insertTask(task: task)
        case .B: taskListVC_B.insertTask(task: task)
        case .C: taskListVC_C.insertTask(task: task)
        case .D: taskListVC_D.insertTask(task: task)
        }
    }
    
    /// TaskListを更新
    /// - Parameters:
    ///   - task: Task
    ///   - indexPath: IndexPath
    private func updateTaskListView(task: Task, indexPath: IndexPath) {
        switch task.type {
        case .A: taskListVC_A.updateTask(indexPath: indexPath)
        case .B: taskListVC_B.updateTask(indexPath: indexPath)
        case .C: taskListVC_C.updateTask(indexPath: indexPath)
        case .D: taskListVC_D.updateTask(indexPath: indexPath)
        }
    }
    
    // MARK: - Character
    
    /// キャラクターの初期化
    @objc private func initCharacterView() {
        changeEventMessage(type: EventMessage.list)
        stopTimer()
        startTimer()
    }
    
    /// キャラクターの画像とメッセージを変更
    /// - Parameter type: タイプ
    private func changeEventMessage(type: EventMessage) {
        characterImageView.image = type.image
        Util.animateLabel(label: characterMessageLabel, text: type.message)
    }
    
    /// キャラクターの画像とメッセージを変更
    /// - Parameter type: タイプ
    private func changeRandomMessage(type: RandomMessage) {
        characterImageView.image = type.image
        let message = homeViewModel.addTaskTitleMessage(type: type)
        Util.animateLabel(label: characterMessageLabel, text: message)
    }
    
    // MARK: - Timer
    
    /// タイマー開始
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(updateCharacterMessage), userInfo: nil, repeats: true)
    }
    
    /// タイマー停止
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    /// キャラクターのコメントを更新
    @objc private func updateCharacterMessage() {
        let randomMessage = homeViewModel.getRandomMessage()
        changeRandomMessage(type: randomMessage)
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
        delegate?.homeVCFilterButtonDidTap(self, filterArray: homeViewModel.getFilterArray())
    }
    
    /// segmentedControl選択
    @IBAction func selectSegmentedControl(_ sender: UISegmentedControl) {
        selectSegment(number: sender.selectedSegmentIndex)
    }
    
    /// SegmentControl選択時の処理
    private func selectSegment(number: Int) {
        segmentedControl.selectedSegmentIndex = number
        moveFrontTaskListView(type: TaskType.allCases[number])
        self.navigationItem.titleView = homeViewModel.getNavigationLabel(type: TaskType.allCases[number])
    }
    
    /// タスク追加
    @IBAction func tapAddButton(_ sender: Any) {
        delegate?.homeVCAddButtonDidTap(self)
    }
    
    /// タスクを挿入(新規追加,未完了に戻す,タイプ更新)
    /// - Parameter task: 挿入する課題
    func insertTask(task: Task) {
        selectSegment(number: task.type.rawValue)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.insertTaskListView(task: task)
        }
        changeEventMessage(type: EventMessage.addTask)
    }
    
    /// フィルタを適用
    /// - Parameter filterArray: チェック配列
    func applyFilter(filterArray: [Bool]) {
        homeViewModel.setFilterArray(array: filterArray)
        applyFilterTaskListView()
        initNavigation()
    }
    
    // MARK: - UIGestureRecognizer
    
    /// ジャスチャ設定
    private func initGestureRecognizer() {
        addRightSwipeGesture()
        addLeftSwipeGesture()
        addTapGesture()
    }
    
    /// 右スワイプでABCD切り替え
    private func addRightSwipeGesture() {
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(rightSwipeTaskList))
        rightSwipe.direction = .right
        taskListView.addGestureRecognizer(rightSwipe)
    }
    
    /// 左スワイプでABCD切り替え
    private func addLeftSwipeGesture() {
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipeTaskList))
        leftSwipe.direction = .left
        taskListView.addGestureRecognizer(leftSwipe)
    }
    
    /// キャラクタータップでキャラクター設定へ遷移
    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapCharacterView))
        characterImageView.addGestureRecognizer(tapGesture)
        characterImageView.isUserInteractionEnabled = true
    }
    
    /// 右スワイプ
    @objc private func rightSwipeTaskList() {
        var selectNo = segmentedControl.selectedSegmentIndex - 1
        if selectNo < TaskType.A.rawValue {
            selectNo = TaskType.A.rawValue
        }
        selectSegment(number: selectNo)
    }
    
    /// 左スワイプ
    @objc private func leftSwipeTaskList() {
        var selectNo = segmentedControl.selectedSegmentIndex + 1
        if selectNo > TaskType.D.rawValue {
            selectNo = TaskType.D.rawValue
        }
        selectSegment(number: selectNo)
    }
    
    /// タップ
    @objc private func tapCharacterView() {
        delegate?.homeVCCharacterDidTap(self)
    }
    
    // MARK: - Notification
    
    /// 通知設定
    private func initNotification() {
        // ログイン時のリロード用
        NotificationCenter.default.addObserver(self, selector: #selector(syncTaskListView), name: NSNotification.Name(rawValue: "afterLogin"), object: nil)
        // ログアウト時のリロード用
        NotificationCenter.default.addObserver(self, selector: #selector(syncTaskListView), name: NSNotification.Name(rawValue: "afterLogout"), object: nil)
        // キャラクター変更時
        NotificationCenter.default.addObserver(self, selector: #selector(initCharacterView), name: NSNotification.Name(rawValue: "afterChangeCharacter"), object: nil)
    }
    
}

extension HomeViewController: TaskListViewControllerDelegate {
    
    /// Taskタップ時
    func taskListVCTaskDidTap(_ viewController: UIViewController, task: Task, indexPath: IndexPath) {
        stopTimer()
        homeViewModel.setTaskIndex(task: task, indexPath: indexPath)
        delegate?.homeVCTaskDidTap(self, task: task)
    }
    
    /// TaskTypeアップデート時
    func taskListVCTaskTypeUpdate(task: Task) {
        insertTask(task: task)
        changeEventMessage(type: EventMessage.update)
    }
    
    /// Task完了時
    func taskListVCTaskComplete(task: Task) {
        changeEventMessage(type: EventMessage.complete)
    }
    
    /// Taskアップデート時
    func taskListVCTaskUpdate() {
        changeEventMessage(type: EventMessage.update)
    }
    
    /// 緊急度自動更新時
    func taskListVCAutoUrgencyUpdate(message: String) {
        let alert = Alert.OK(title: TITLE_AUTO_UPDATE_URGENCY, message: message, OKAction: {
            self.syncTaskListView()
        })
        present(alert, animated: true)
    }
    
    /// Task同期時
    func taskListVCSyncTask() {
        syncTaskListView()
    }
    
}
