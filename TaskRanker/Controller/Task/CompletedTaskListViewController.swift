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
}

class CompletedTaskListViewController: UIViewController {

    // MARK: - UI,Variable
    
    @IBOutlet weak var naviItem: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    private var taskArray = [Task]()
    var delegate: CompletedTaskListViewControllerDelegate?

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshData()
        initView()
        initTableView()
    }
    
    /// データ取得
    private func refreshData() {
        let taskManager = TaskManager()
        taskArray = taskManager.getTask(isComplete: true)
    }
    
    /// 画面初期化
    private func initView() {
//        naviItem.title = TITLE_COMPLETE_TASK
    }
    
    // MARK: - Action
    
    /// キャンセルボタンタップ時
    @IBAction func tapCancelButton(_ sender: Any) {
        delegate?.completedTaskListVCDismiss(self)
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
        cell.textLabel?.text = task.title
        cell.detailTextLabel?.text = task.memo
        cell.detailTextLabel?.textColor = UIColor.lightGray
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
