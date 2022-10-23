//
//  TaskListViewController.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2022/09/11.
//

import UIKit

protocol TaskListViewControllerDelegate: AnyObject {
    // infoボタンタップ時
    func taskListVCInfoButtonDidTap(_ viewController: UIViewController, task: Task)
}

class TaskListViewController: UIViewController {
    
    // MARK: - UI,Variable
    
    @IBOutlet weak var tableView: UITableView!
    var segmentType: SegmentType
    var taskArray = [Task]()
    var delegate: TaskListViewControllerDelegate?
    
    // MARK: - LifeCycle
    
    init(segmentType: SegmentType) {
        self.segmentType = segmentType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        refreshData()
    }
    
    /// TableView初期化
    private func initTableView() {
        tableView.tableFooterView = UIView()
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(syncData), for: .valueChanged)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }
    
    /// データの同期処理
    @objc func syncData() {
        refreshData()
    }
    
    /// データを再取得
    func refreshData() {
        let taskManager = TaskManager()
        taskArray = taskManager.getTask(type: segmentType)
        tableView.refreshControl?.endRefreshing()
        tableView.reloadData()
    }
    
    /// タスクを挿入
    /// - Parameters:
    ///   - task: 挿入する課題
    func insertTask(task: Task) {
        taskArray.append(task)
        // TODO: 重要度が高い順に並び替える
        let index: IndexPath = [0, taskArray.count - 1]
        tableView.insertRows(at: [index], with: UITableView.RowAnimation.right)
    }

}

extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let task = taskArray[indexPath.row]
        let symbolName = task.isComplete ? "circle.fill" : "circle"
        let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .title1)
        cell.imageView?.image = UIImage(systemName: symbolName, withConfiguration: symbolConfiguration)
        cell.detailTextLabel?.text = task.title
        cell.accessoryType = .detailButton
        return cell
    }
    
    /// infoボタンタップ時
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let task = taskArray[indexPath.row]
        delegate?.taskListVCInfoButtonDidTap(self, task: task)
    }
    
}
