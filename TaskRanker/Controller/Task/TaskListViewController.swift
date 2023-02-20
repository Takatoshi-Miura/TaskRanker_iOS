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
}

class TaskListViewController: UIViewController {
    
    // MARK: - UI,Variable
    
    @IBOutlet weak var tableView: UITableView!
    private var segmentType: SegmentType
    private var taskArray = [Task]()
    private var filterArray: [Bool]?
    var delegate: TaskListViewControllerDelegate?
    
    // MARK: - Initializer
    
    /// イニシャライザ
    /// - Parameter segmentType: タスクタイプ(ABCD)
    init(segmentType: SegmentType) {
        self.segmentType = segmentType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshData()
        initTableView()
    }
    
    /// データの同期処理
    @objc func syncData() {
        if filterArray != nil {
            applyFilter(filterArray: filterArray!)
        } else {
            refreshData()
        }
    }
    
    /// データを再取得
    func refreshData() {
        self.filterArray = nil
        let taskManager = TaskManager()
        taskArray = taskManager.getTask(type: segmentType)
        reloadTableView()
    }
    
    /// フィルタを適用
    /// - Parameter filterArray: フィルタ配列
    func applyFilter(filterArray: [Bool]) {
        self.filterArray = filterArray
        let taskManager = TaskManager()
        taskArray = taskManager.getTask(type: segmentType, filterArray: filterArray)
        reloadTableView()
    }
    
    /// タスクを挿入
    /// - Parameter task: 挿入するタスク
    func insertTask(task: Task) {
        // 重要度が高い順に並び替え
        taskArray.append(task)
        taskArray = taskArray.sorted(by: {
            $0.importance > $1.importance
        })
        if let index = taskArray.firstIndex(where: {$0.taskID == task.taskID}) {
            let indexPath: IndexPath = [0, index]
            tableView.insertRows(at: [indexPath], with: UITableView.RowAnimation.right)
            updateTableFooterView()
        }
        
    }
    
    /// タスクを更新
    /// - Parameter indexPath: 選択したタスクのIndexPath
    func updateTask(indexPath: IndexPath) {
        // 完了,削除,タスクタイプ変更されたタスクを取り除く
        let taskManager = TaskManager()
        if let selectedTask = taskManager.getTask(taskID: taskArray[indexPath.row].taskID) {
            if selectedTask.isComplete || selectedTask.isDeleted || selectedTask.type != segmentType {
                taskArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.left)
                updateTableFooterView()
                // type変更時は当該タイプにTaskを移動
                if selectedTask.type != segmentType {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        self.delegate?.taskListVCTaskTypeUpdate(task: selectedTask)
                    }
                }
                return
            }
            taskArray[indexPath.row] = selectedTask
        }
        // タスクを更新
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
        updateTableFooterView()
    }
    
    /// 0件表示切替用
    private func updateTableFooterView() {
        tableView.tableFooterView = taskArray.count == 0 ? createZeroTaskView() : UIView()
    }
    
    /// タスクの0件表示View作成
    /// - Returns: 0件表示UIView
    private func createZeroTaskView() -> UIView {
        let label = UILabel()
        label.text = MESSAGE_ZERO_TASK
        label.textColor = .systemGray
        label.textAlignment = NSTextAlignment.center
        label.sizeToFit()
        label.frame = CGRect(x: UIScreen.main.bounds.size.width/2 - label.frame.width/2,
                             y: 100,
                             width: label.frame.width,
                             height: label.frame.height)
        let view = UIView()
        view.addSubview(label)
        return view
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let task = taskArray[indexPath.row]
        let symbolName = task.isComplete ? "checkmark.circle" : "circle"
        let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .title1)
        cell.imageView?.isUserInteractionEnabled = true
        cell.imageView?.image = UIImage(systemName: symbolName, withConfiguration: symbolConfiguration)
        cell.imageView?.tintColor = task.color.color
        cell.imageView!.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(completeTask(_:))))
        cell.textLabel?.text = task.title
        cell.detailTextLabel?.text = (task.deadlineDate != nil) ? getDeadlineDateString(date: task.deadlineDate!) : ""
        cell.detailTextLabel?.textColor = UIColor.lightGray
        cell.accessoryType = .disclosureIndicator
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
        var task = taskArray[tappedIndexPath!.row]
        task.isComplete = true
        let taskManager = TaskManager()
        taskManager.updateTask(task: task)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.updateTask(indexPath: tappedIndexPath!)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // タスク編集画面へ遷移
        let task = taskArray[indexPath.row]
        delegate?.taskListVCTaskDidTap(self, task: task ,indexPath: indexPath)
    }
    
}
