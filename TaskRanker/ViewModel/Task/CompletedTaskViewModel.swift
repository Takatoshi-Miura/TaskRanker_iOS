//
//  CompletedTaskViewModel.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2023/03/16.
//

import UIKit

class CompletedTaskViewModel {
    
    // MARK: - Variable
    
    private var taskArray = [Task]()
    
    // MARK: - Initializer
    
    init() {
        loadTaskData()
    }
    
    /// データ取得
    private func loadTaskData() {
        let taskManager = TaskManager()
        taskArray = taskManager.getTask(isComplete: true)
    }
    
    // MARK: - TableView DataSource
    
    /// Taskの数を取得
    /// - Returns: Taskの数
    func getTaskCount() -> Int {
        return taskArray.count
    }
    
    /// セルを取得
    /// - Parameter indexPath: IndexPath
    /// - Returns: セル
    func getTaskCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let task = getTask(indexPath: indexPath)
        let taskManager = TaskManager()
        let isQuicklyTask = taskManager.isQuicklyTask(task: task)
        let isExpiredTask = taskManager.isExpiredTask(task: task)
        let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .title1)
        cell.imageView?.isUserInteractionEnabled = true
        cell.imageView?.image = UIImage(systemName: "checkmark.circle", withConfiguration: symbolConfiguration)
        cell.imageView?.tintColor = TaskColor.allCases[task.color].color
        cell.textLabel?.text = task.title
        cell.detailTextLabel?.text = (task.deadlineDate != nil) ? Converter.deadlineDateString(date: task.deadlineDate!) : ""
        if isQuicklyTask {
            cell.detailTextLabel?.textColor = UIColor.systemOrange
        } else if isExpiredTask {
            cell.detailTextLabel?.textColor = UIColor.systemRed
        } else {
            cell.detailTextLabel?.textColor = UIColor.lightGray
        }
        let deleteImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        deleteImage.image = UIImage(systemName: "trash")
        deleteImage.tintColor = UIColor.red
        deleteImage.isUserInteractionEnabled = true
        cell.accessoryView = deleteImage
        return cell
    }
    
    /// Taskを取得
    /// - Parameter indexPath: IndexPath
    /// - Returns: Task
    func getTask(indexPath: IndexPath) -> Task {
        return taskArray[indexPath.row]
    }
    
    /// Taskを未完了にする
    /// - Parameter indexPath: IndexPath
    /// - Returns: 未完了にしたTask
    func inCompleteTask(indexPath: IndexPath) -> Task {
        var task = getTask(indexPath: indexPath)
        task.isComplete = false
        let taskManager = TaskManager()
        taskManager.updateTask(task: task)
        taskArray.remove(at: indexPath.row)
        return task
    }
    
    /// Taskを削除
    /// - Parameter indexPath: IndexPath
    func deleteTask(indexPath: IndexPath) {
        var task = getTask(indexPath: indexPath)
        task.isDeleted = true
        let taskManager = TaskManager()
        taskManager.updateTask(task: task)
        taskArray.remove(at: indexPath.row)
    }
    
}
