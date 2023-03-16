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
    private var completedTaskViewModel = CompletedTaskViewModel()
    var delegate: CompletedTaskListViewControllerDelegate?

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigation()
        initTableView()
    }
    
    // MARK: - Viewer
    
    /// NavigationController初期化
    private func initNavigation() {
        self.title = TITLE_COMPLETE_TASK_LIST
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(tapCloseButton(_:)))
        navigationItem.leftBarButtonItems = [closeButton]
    }
    
    // MARK: - Action
    
    /// 閉じる
    @objc func tapCloseButton(_ sender: UIBarButtonItem) {
        delegate?.completedTaskListVCDismiss(self)
    }
    
    /// タスクを未完了にする
    @objc func inCompleteTask(_ sender : UITapGestureRecognizer) {
        let tappedIndexPath = getTappedIndexPath(sender)
        tableView.selectRow(at: tappedIndexPath, animated: false, scrollPosition: .none)
        
        let alert = Alert.OKCancel(title: TITLE_COMPLETE_TASK, message: MESSAGE_INCOMPLETE_TASK, OKAction: {
            // タスクを未完了にしてHome画面に戻る
            let task = self.completedTaskViewModel.inCompleteTask(indexPath: tappedIndexPath)
            self.tableView.deleteRows(at: [tappedIndexPath], with: UITableView.RowAnimation.left)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.delegate?.completedTaskListVCTaskInComplete(self, task: task)
            }
        })
        present(alert, animated: true)
    }
    
    /// タスクを削除
    @objc func deleteTask(_ sender : UITapGestureRecognizer) {
        let tappedIndexPath = getTappedIndexPath(sender)
        tableView.selectRow(at: tappedIndexPath, animated: false, scrollPosition: .none)
        
        let alert = Alert.Delete(title: TITLE_DELETE_TASK, message: MESSAGE_DELETE_TASK, OKAction: {
            // タスクを削除
            self.completedTaskViewModel.deleteTask(indexPath: tappedIndexPath)
            self.tableView.deleteRows(at: [tappedIndexPath], with: UITableView.RowAnimation.left)
        })
        present(alert, animated: true)
    }
    
    /// タップした位置からIndexPathを取得
    private func getTappedIndexPath(_ sender : UITapGestureRecognizer) -> IndexPath {
        let tappedLocation = sender.location(in: tableView)
        let tappedIndexPath = tableView.indexPathForRow(at: tappedLocation)!
        return tappedIndexPath
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
        return completedTaskViewModel.getTaskCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = completedTaskViewModel.getTaskCell(indexPath: indexPath)
        cell.imageView!.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(inCompleteTask(_:))))
        cell.accessoryView!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deleteTask(_:))))
        return cell
    }
    
}
