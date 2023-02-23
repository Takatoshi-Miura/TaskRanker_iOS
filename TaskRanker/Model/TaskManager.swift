//
//  TaskManager.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2022/10/14.
//

import Foundation

class TaskManager {
    
    private let realmManager = RealmManager()
    
    /// Taskを保存
    /// - Parameter task: Task
    /// - Returns: 成功(true), 失敗(false)
    func saveTask(task: Task) -> Bool {
        let realmTask = RealmTask()
        realmTask.taskID = task.taskID
        realmTask.title = task.title
        realmTask.memo = task.memo
        realmTask.color = task.color.rawValue
        realmTask.importance = task.importance
        realmTask.urgency = task.urgency
        realmTask.deadlineDate = task.deadlineDate
        return realmManager.createRealm(object: realmTask) ? true : false
    }
    
    /// 未完了Taskを全取得
    /// - Returns: Task配列
    func getTask() -> [Task] {
        var taskArray = [Task]()
        let realmTaskArray = realmManager.getIncompleteTask()
        for realmTask in realmTaskArray {
            let task = Task(realmTask: realmTask)
            taskArray.append(task)
        }
        return taskArray
    }
    
    /// Taskを取得
    /// - Parameter type: A,B,C,D
    /// - Returns: Task配列(重要度が高い順)
    func getTask(type: SegmentType) -> [Task] {
        var taskArray = [Task]()
        let realmTaskArray = realmManager.getIncompleteTask()
        for realmTask in realmTaskArray {
            let task = Task(realmTask: realmTask)
            if task.type == type {
                taskArray.append(task)
            }
        }
        // 重要度が高い順に並び替え
        taskArray = taskArray.sorted(by: {
            $0.importance > $1.importance
        })
        return taskArray
    }
    
    /// Taskを取得
    /// - Parameters:
    ///   - type: A,B,C,D
    ///   - filterArray: カラーBool配列
    /// - Returns: Task配列(重要度が高い順)
    func getTask(type: SegmentType, filterArray: [Bool]) -> [Task] {
        var taskArray = [Task]()
        let realmTaskArray = realmManager.getIncompleteTask(filterArray: filterArray)
        for realmTask in realmTaskArray {
            let task = Task(realmTask: realmTask)
            if task.type == type {
                taskArray.append(task)
            }
        }
        // 重要度が高い順に並び替え
        taskArray = taskArray.sorted(by: {
            $0.importance > $1.importance
        })
        return taskArray
    }
    
    /// Taskを取得
    /// - Parameter isComplete: true:完了済み, false:未完了
    /// - Returns: Task配列
    func getTask(isComplete: Bool) -> [Task] {
        var taskArray = [Task]()
        let realmTaskArray = realmManager.getCompleteTask()
        for realmTask in realmTaskArray {
            taskArray.append(Task(realmTask: realmTask))
        }
        return taskArray
    }
    
    /// Taskを取得
    /// - Parameter taskID: taskID
    /// - Returns: Task
    func getTask(taskID: String) -> Task? {
        if let realmTask = realmManager.getTask(taskID: taskID) {
            return Task(realmTask: realmTask)
        } else {
            return nil
        }
    }
    
    /// Taskを更新
    /// - Parameter task: Task
    func updateTask(task: Task) {
        guard let oldTask = getTask(taskID: task.taskID) else {
            return
        }
        if task.title != oldTask.title {
            realmManager.updateTaskTitle(taskID: task.taskID, title: task.title)
        }
        if task.memo != oldTask.memo {
            realmManager.updateTaskMemo(taskID: task.taskID, memo: task.memo)
        }
        if task.color != oldTask.color {
            realmManager.updateTaskColor(taskID: task.taskID, color: task.color.rawValue)
        }
        if task.importance != oldTask.importance {
            realmManager.updateTaskImportance(taskID: task.taskID, importance: task.importance)
        }
        if task.urgency != oldTask.urgency {
            realmManager.updateTaskUrgency(taskID: task.taskID, urgency: task.urgency)
        }
        if task.deadlineDate != oldTask.deadlineDate {
            realmManager.updateTaskDeadlineDate(taskID: task.taskID, deadlineDate: task.deadlineDate)
        }
        if task.isComplete != oldTask.isComplete {
            realmManager.updateTaskIsComplete(taskID: task.taskID, isComplete: task.isComplete)
        }
        if task.isDeleted != oldTask.isDeleted {
            realmManager.updateTaskIsDeleted(taskID: task.taskID, isDeleted: task.isDeleted)
        }
    }
    
}
