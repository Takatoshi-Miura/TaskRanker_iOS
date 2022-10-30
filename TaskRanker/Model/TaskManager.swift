//
//  TaskManager.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2022/10/14.
//

import Foundation

class TaskManager {
    
    private let realmManager = RealmManager()
    
    /// Taskを取得
    /// - Parameters:
    ///   - type: A,B,C,D
    /// - Returns: Task配列
    func getTask(type: SegmentType) -> [Task] {
        var taskArray = [Task]()
        let realmTaskArray = realmManager.getIncompleteTask()
        for realmTask in realmTaskArray {
            let task = Task(realmTask: realmTask)
            if task.type == type {
                taskArray.append(task)
            }
        }
        return taskArray
    }
    
    /// Taskを取得
    /// - Parameters:
    ///   - type: A,B,C,D
    ///   - filterArray: カラーBool配列
    /// - Returns: Task配列
    func getTask(type: SegmentType, filterArray: [Bool]) -> [Task] {
        var taskArray = [Task]()
        let realmTaskArray = realmManager.getIncompleteTask(filterArray: filterArray)
        for realmTask in realmTaskArray {
            let task = Task(realmTask: realmTask)
            if task.type == type {
                taskArray.append(task)
            }
        }
        return taskArray
    }
    
    /// Taskを取得
    /// - Parameters:
    ///   - isComplete: true:完了済み, false:未完了
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
    /// - Parameters:
    ///   - taskID: taskID
    /// - Returns: Task
    func getTask(taskID: String) -> Task? {
        if let realmTask = realmManager.getTask(taskID: taskID) {
            return Task(realmTask: realmTask)
        } else {
            return nil
        }
    }
    
    /// Taskを更新
    /// - Parameters:
    ///   - task: Task
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
            realmManager.updateTaskColor(taskID: task.taskID, color: task.color)
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
        if task.isRepeat != oldTask.isRepeat {
            realmManager.updateTaskIsRepeat(taskID: task.taskID, isRepeat: task.isRepeat)
        }
        if task.isComplete != oldTask.isComplete {
            realmManager.updateTaskIsComplete(taskID: task.taskID, isComplete: task.isComplete)
        }
        if task.isDeleted != oldTask.isDeleted {
            realmManager.updateTaskIsDeleted(taskID: task.taskID, isDeleted: task.isDeleted)
        }
    }
    
}
