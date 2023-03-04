//
//  CompletedTaskListViewController.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2022/10/24.
//

import UIKit

protocol CompletedTaskListViewControllerDelegate: AnyObject {
    /// モーダルを閉じる
    func completedTaskListVCDismiss(_ viewController: UIViewController)
    /// タスク未完了時
    func completedTaskListVCTaskInComplete(_ viewController: UIViewController, task: Task)
}

class CompletedTaskListViewController: UIViewController {

    // MARK: - UI,Variable
    
    @IBOutlet weak var tableView: UITableView!
    private var taskArray = [Task]()
    var delegate: CompletedTaskListViewControllerDelegate?

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshData()
        initNavigation()
        initTableView()
    }
    
    /// データ取得
    private func refreshData() {
        let taskManager = TaskManager()
        taskArray = taskManager.getTask(isComplete: true)
    }
    
    // MARK: - Viewer
    
    /// NavigationController初期化
    private func initNavigation() {
        self.title = TITLE_COMPLETE_TASK_LIST
        
        // 閉じるボタン
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close,
                                          target: self,
                                          action: #selector(tapCloseButton(_:)))
        
        navigationItem.leftBarButtonItems = [closeButton]
    }
    
    // MARK: - Action
    
    /// 閉じる
    @objc func tapCloseButton(_ sender: UIBarButtonItem) {
        delegate?.completedTaskListVCDismiss(self)
    }
    
    /// タスクを未完了にする
    @objc func inCompleteTask(_ sender : UITapGestureRecognizer) {
        // IndexPathを取得
        let tappedLocation = sender.location(in: self.tableView)
        let tappedIndexPath = self.tableView.indexPathForRow(at: tappedLocation)
        tableView.selectRow(at: tappedIndexPath, animated: false, scrollPosition: .none)
        
        showOKCancelAlert(title: TITLE_COMPLETE_TASK, message: MESSAGE_INCOMPLETE_TASK, OKAction: {
            // チェックを外す
            let cell = self.tableView.cellForRow(at: tappedIndexPath!)
            let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .title1)
            cell?.imageView?.image = UIImage(systemName: "circle", withConfiguration: symbolConfiguration)
            
            // タスクを未完了にする
            var task = self.taskArray[tappedIndexPath!.row]
            task.isComplete = false
            let taskManager = TaskManager()
            taskManager.updateTask(task: task)
            
            // Home画面に戻る
            self.taskArray.remove(at: tappedIndexPath!.row)
            self.tableView.deleteRows(at: [tappedIndexPath!], with: UITableView.RowAnimation.left)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.delegate?.completedTaskListVCTaskInComplete(self, task: task)
            }
        })
    }
    
    /// タスクを削除
    @objc func deleteTask(_ sender : UITapGestureRecognizer) {
        // IndexPathを取得
        let tappedLocation = sender.location(in: self.tableView)
        let tappedIndexPath = self.tableView.indexPathForRow(at: tappedLocation)!
        tableView.selectRow(at: tappedIndexPath, animated: false, scrollPosition: .none)
        
        // タスクを削除
        showDeleteAlert(title: TITLE_DELETE_TASK, message: MESSAGE_DELETE_TASK, OKAction: {
            var task = self.taskArray[tappedIndexPath.row]
            task.isComplete = false
            let taskManager = TaskManager()
            taskManager.updateTask(task: task)
            self.taskArray.remove(at: tappedIndexPath.row)
            self.tableView.deleteRows(at: [tappedIndexPath], with: UITableView.RowAnimation.left)
        })
    }

}

extension CompletedTaskListViewController: UITableViewDataSource, UITableViewDelegate {
    
    /// TableView初期化
    private func initTableView() {
        tableView.tableFooterView = UIView()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
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
        cell.imageView?.tintColor = TaskColor.allCases[task.color].color
        cell.imageView!.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(inCompleteTask(_:))))
        cell.textLabel?.text = task.title
        cell.detailTextLabel?.text = (task.deadlineDate != nil) ? getDeadlineDateString(date: task.deadlineDate!) : ""
        cell.detailTextLabel?.textColor = UIColor.lightGray
        
        let deleteImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        deleteImage.image = UIImage(systemName: "trash")
        deleteImage.tintColor = UIColor.red
        deleteImage.isUserInteractionEnabled = true
        deleteImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deleteTask(_:))))
        cell.accessoryView = deleteImage
        return cell
    }
    
}
