//
//  TaskListViewModel.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2023/03/17.
//

import UIKit

class TaskListViewModel {
    
    // MARK: - Variable
    
    var taskType: TaskType
    private var filterArray: [Bool]
    private var taskArray = [Task]()
    private var updateUrgencyMessage = MESSAGE_UPDATE_URGENCY
    
    // MARK: - Initializer
    
    init(taskType: TaskType, filterArray: [Bool]) {
        self.taskType = taskType
        self.filterArray = filterArray
    }
    
    // MARK: - TableView DataSource
    
    /// Taskを取得
    /// - Parameter filterArray: フィルタ配列
    func getTaskData(filterArray: [Bool]) {
        self.filterArray = filterArray
        let taskManager = TaskManager()
        taskArray = taskManager.getTask(type: taskType, filterArray: filterArray)
    }
    
    /// Taskの件数を取得
    /// - Returns: Taskの件数
    func getTaskCount() -> Int {
        return taskArray.count
    }
    
    /// Taskを取得
    /// - Parameter indexPath: IndexPath
    /// - Returns: Task
    func getTask(indexPath: IndexPath) -> Task {
        return taskArray[indexPath.row]
    }
    
    /// セルを取得
    /// - Parameter indexPath: IndexPath
    /// - Returns: セル
    func getTaskCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let task = taskArray[indexPath.row]
        let symbolName = task.isComplete ? "checkmark.circle" : "circle"
        let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .title1)
        cell.imageView?.isUserInteractionEnabled = true
        cell.imageView?.image = UIImage(systemName: symbolName, withConfiguration: symbolConfiguration)
        cell.imageView?.tintColor = TaskColor.allCases[task.color].color
        cell.textLabel?.text = task.title
        cell.detailTextLabel?.text = (task.deadlineDate != nil) ? Converter.deadlineDateString(date: task.deadlineDate!) : ""
        cell.detailTextLabel?.textColor = UIColor.lightGray
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    /// TableViewのフッターを取得
    /// - Returns: UIView
    func getTableFooterView() -> UIView {
        let view = UIView()
        if taskArray.count > 0 {
            return view
        }
        let label = UILabel()
        label.text = MESSAGE_ZERO_TASK
        label.textColor = .systemGray
        label.textAlignment = NSTextAlignment.center
        label.sizeToFit()
        label.frame = CGRect(x: UIScreen.main.bounds.size.width/2 - label.frame.width/2, y: 100, width: label.frame.width, height: label.frame.height)
        view.addSubview(label)
        return view
    }
    
    // MARK: - Action
    
    /// Taskの同期処理
    func syncTask() {
        // 緊急度自動更新
        let taskManager = TaskManager()
        updateUrgencyMessage = taskManager.autoUpdateUrgency()
        
        if UserDefaultsKey.useFirebase.bool() && Device.isOnline() {
            taskManager.syncDatabase(completion: {
                self.getTaskData(filterArray: self.filterArray)
            })
        } else {
            self.getTaskData(filterArray: self.filterArray)
        }
    }
    
    /// Taskを追加
    /// - Parameter task: Task
    /// - Returns: Taskの挿入位置
    func insertTask(task: Task) -> IndexPath? {
        taskArray.append(task)
        taskArray = taskArray.sorted(by: {$0.importance > $1.importance})
        // 挿入位置を返却
        var indexPath: IndexPath?
        if let index = taskArray.firstIndex(where: {$0.taskID == task.taskID}) {
            indexPath = [0, index]
        }
        return indexPath
    }
    
    /// Taskを更新
    /// - Parameter indexPath: 選択したTaskのIndexPath
    /// - Returns: Viewから削除するTask（nil可）
    func updateTask(indexPath: IndexPath) -> Task? {
        var task: Task?
        let taskManager = TaskManager()
        if let selectedTask = taskManager.getTask(taskID: taskArray[indexPath.row].taskID) {
            // 完了,削除,Taskタイプが変更されたTaskを削除
            if selectedTask.isComplete || selectedTask.isDeleted || selectedTask.type != taskType {
                taskArray.remove(at: indexPath.row)
                task = selectedTask
                return task
            }
            // 更新
            taskArray[indexPath.row] = selectedTask
        }
        return task
    }
    
    /// Taskを完了にする（DBのみ更新）
    /// - Parameter indexPath: IndexPath
    func completeTask(indexPath: IndexPath) {
        var task = taskArray[indexPath.row]
        task.isComplete = true
        let taskManager = TaskManager()
        taskManager.updateTask(task: task)
    }
    
    /// 緊急度自動更新メッセージを取得
    /// - Returns: メッセージ
    func getUpdateUrgencyMessage() -> String {
        return updateUrgencyMessage
    }
    
}
