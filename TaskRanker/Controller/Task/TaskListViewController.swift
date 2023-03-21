//
//  TaskListViewController.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2022/09/11.
//

import UIKit

protocol TaskListViewControllerDelegate: AnyObject {
    /// Taskタップ時
    func taskListVCTaskDidTap(_ viewController: UIViewController, task: Task, indexPath: IndexPath)
    /// TaskTypeアップデート時
    func taskListVCTaskTypeUpdate(task: Task)
    /// Taskアップデート時
    func taskListVCTaskUpdate(task: Task)
    /// 緊急度自動更新時
    func taskListVCAutoUrgencyUpdate(message: String)
}

class TaskListViewController: UIViewController {
    
    // MARK: - UI,Variable
    
    @IBOutlet weak var tableView: UITableView!
    private var taskListViewModel: TaskListViewModel
    var delegate: TaskListViewControllerDelegate?
    
    // MARK: - Initializer
    
    /// イニシャライザ
    /// - Parameter taskType: タスクタイプ(ABCD)
    init(taskType: TaskType, filterArray: [Bool]) {
        taskListViewModel = TaskListViewModel(taskType: taskType, filterArray: filterArray)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        syncData()
        initTableView()
    }
    
    // MARK: - LifeCycle
    
    /// データの同期処理
    @objc func syncData() {
        taskListViewModel.syncTask()
        reloadTableView()
    }
    
    /// フィルタを適用
    /// - Parameter filterArray: フィルタ配列
    func applyFilter(filterArray: [Bool]) {
        taskListViewModel.getTaskData(filterArray: filterArray)
        reloadTableView()
    }
    
    /// Taskを挿入
    /// - Parameter task: 挿入するタスク
    func insertTask(task: Task) {
        if let indexPath = taskListViewModel.insertTask(task: task) {
            tableView.insertRows(at: [indexPath], with: UITableView.RowAnimation.right)
            tableView.tableFooterView = taskListViewModel.getTableFooterView()
        }
    }
    
    /// タスクを更新
    /// - Parameter indexPath: 選択したタスクのIndexPath
    func updateTask(indexPath: IndexPath) {
        if let deleteTask = taskListViewModel.updateTask(indexPath: indexPath) {
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.left)
            tableView.tableFooterView = taskListViewModel.getTableFooterView()
            // type変更時は当該タイプにTaskを移動
            if deleteTask.type != taskListViewModel.taskType {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.delegate?.taskListVCTaskTypeUpdate(task: deleteTask)
                }
                return
            }
            if deleteTask.isComplete == true {
                self.delegate?.taskListVCTaskUpdate(task: deleteTask)
            }
            return
        }
        tableView.reloadRows(at: [indexPath], with: .none)
    }

}

extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
    
    /// TableView初期化
    private func initTableView() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(syncData), for: .valueChanged)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        reloadTableView()
    }
    
    /// TableViewのリロード
    private func reloadTableView() {
        tableView.refreshControl?.endRefreshing()
        tableView.reloadData()
        tableView.tableFooterView = taskListViewModel.getTableFooterView()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            let message = self.taskListViewModel.getUpdateUrgencyMessage()
            if (message != MESSAGE_UPDATE_URGENCY) {
                self.delegate?.taskListVCAutoUrgencyUpdate(message: message)
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskListViewModel.getTaskCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = taskListViewModel.getTaskCell(indexPath: indexPath)
        cell.imageView!.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(completeTask(_:))))
        return cell
    }
    
    /// タスクを完了にする
    @objc func completeTask(_ sender : UITapGestureRecognizer)  {
        // IndexPathを取得
        let tappedLocation = sender.location(in: tableView)
        let tappedIndexPath = tableView.indexPathForRow(at: tappedLocation)
        
        // チェックをつける
        let cell = tableView.cellForRow(at: tappedIndexPath!)
        let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .title1)
        cell?.imageView?.image = UIImage(systemName: "checkmark.circle", withConfiguration: symbolConfiguration)
        
        // タスクを完了にする
        taskListViewModel.completeTask(indexPath: tappedIndexPath!)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.updateTask(indexPath: tappedIndexPath!)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // タスク編集画面へ遷移
        let task = taskListViewModel.getTask(indexPath: indexPath)
        delegate?.taskListVCTaskDidTap(self, task: task ,indexPath: indexPath)
    }
    
}
