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
        let realmTaskArray = realmManager.getAllTask()
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
    ///   - taskID: taskID
    /// - Returns: Task
    func getTask(taskID: String) -> Task? {
        if let realmTask = realmManager.getTask(taskID: taskID) {
            return Task(realmTask: realmTask)
        } else {
            return nil
        }
    }
    
}
