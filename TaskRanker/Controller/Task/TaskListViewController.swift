//
//  TaskListViewController.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2022/09/11.
//

import UIKit

protocol TaskListViewControllerDelegate: AnyObject {
    
}

class TaskListViewController: UIViewController {
    
    // MARK: - UI,Variable
    
    @IBOutlet weak var tableView: UITableView!
    var segmentType = SegmentType.A
    // var taskArray = [Task]()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
    }
    
    /// TableView初期化
    private func initTableView() {
        tableView.tableFooterView = UIView()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }

}

extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1    // セクションの個数
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
//        return taskArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        // TODO: Taskの完了状態で判断させる
        let symbolName = false ? "circle.fill" : "circle"
        let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .title1)
        cell.imageView?.image = UIImage(systemName: symbolName, withConfiguration: symbolConfiguration)
        cell.accessoryType = .detailButton
        
        switch segmentType {
        case .A: cell.detailTextLabel?.text = "タスクAのタイトル"
        case .B: cell.detailTextLabel?.text = "タスクBのタイトル"
        case .C: cell.detailTextLabel?.text = "タスクCのタイトル"
        case .D: cell.detailTextLabel?.text = "タスクDのタイトル"
        }
        return cell
    }
    
}
