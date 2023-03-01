//
//  TaskManager.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2022/10/14.
//

import Foundation

class TaskManager {
    
    private let realmManager = RealmManager()
    private let firebaseManager = FirebaseManager()
    
    // MARK: - Realm-Firebase同期用
    
    /// RaalmとFirebaseのデータを同期
    /// - Parameter completion: 完了処理
    func syncDatabase(completion: @escaping () -> ()) {
        // Realmはスレッドを超えてはいけないため同期的に処理を行う
        // 各データ毎に専用のスレッドを作成して処理を行う
        DispatchQueue.global(qos: .default).sync {
            syncTask(completion: completion)
        }
    }
    
    /// Taskを同期
    /// - Parameters:
    ///   - completion: 完了処理
    private func syncTask(completion: @escaping () -> ()) {
        // RealmのTaskを全取得
        let realmTaskArray = self.getAllTask()
        
        // FirebaseのTaskを全取得
        firebaseManager.getAllTask(completion: {
            // FirebaseもしくはRealmにしか存在しないデータを抽出
            let firebaseTaskIDArray = self.getTaskIDArray(array: self.firebaseManager.taskArray)
            let realmTaskIDArray = self.getTaskIDArray(array: realmTaskArray)
            let onlyRealmID = realmTaskIDArray.subtracting(firebaseTaskIDArray)
            let onlyFirebaseID = firebaseTaskIDArray.subtracting(realmTaskIDArray)
            
            // Realmにしか存在しないデータをFirebaseに保存
            for taskID in onlyRealmID {
                let task = self.getTaskWithID(array: realmTaskArray, ID: taskID)
                self.firebaseManager.saveTask(task: task, completion: {})
            }
            
            // Firebaseにしか存在しないデータをRealmに保存
            for taskID in onlyFirebaseID {
                let task = self.getTaskWithID(array: self.firebaseManager.taskArray, ID: taskID)
                if !self.saveTask(task: task) {
                    return
                }
            }
            
            // どちらにも存在するデータの更新日時を比較し新しい方に更新する
            let commonID = realmTaskIDArray.subtracting(onlyRealmID)
            for taskID in commonID {
                let realmTask = self.getTaskWithID(array: realmTaskArray, ID: taskID)
                let firebaseTask = self.getTaskWithID(array: self.firebaseManager.taskArray, ID: taskID)
                
                if realmTask.updated_at > firebaseTask.updated_at {
                    // Realmデータの方が新しい
                    self.firebaseManager.updateTask(task: realmTask)
                } else if firebaseTask.updated_at > realmTask.updated_at  {
                    // Firebaseデータの方が新しい
                    self.updateTask(task: firebaseTask)
                }
            }
            completion()
        })
    }
    
    /// Task配列からtaskID配列を作成
    /// - Parameter array: Task配列
    /// - Returns: taskID配列
    private func getTaskIDArray(array: [Task]) -> [String] {
        var taskIDArray: [String] = []
        for task in array {
            taskIDArray.append(task.taskID)
        }
        return taskIDArray
    }
    
    /// Task配列からTaskを取得(taskID指定)
    /// - Parameters:
    ///   - array: 検索対象のTask配列
    ///   - ID: 取得したいTaskのID
    /// - Returns: Task
    private func getTaskWithID(array :[Task], ID: String) -> Task {
        return array.filter{ $0.taskID.contains(ID) }.first!
    }
    
    // MARK: - Select
    
    /// Taskを全取得
    /// - Returns: 全Taskデータ
    func getAllTask() -> [Task] {
        var taskArray = [Task]()
        let realmTaskArray = realmManager.getAllTask()
        for realmTask in realmTaskArray {
            taskArray.append(Task(realmTask: realmTask))
        }
        return taskArray
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
    
    // MARK: - Insert
    
    /// Taskを保存
    /// - Parameter task: Task
    /// - Returns: 成功(true), 失敗(false)
    func saveTask(task: Task) -> Bool {
        let realmTask = RealmTask()
        realmTask.taskID = task.taskID
        realmTask.title = task.title
        realmTask.memo = task.memo
        realmTask.color = task.color
        realmTask.importance = task.importance
        realmTask.urgency = task.urgency
        realmTask.deadlineDate = task.deadlineDate
        let result = realmManager.createRealm(object: realmTask)
        if !result  { return result }
        
        if UserDefaultsKey.useFirebase.bool() && Network.isOnline() {
            firebaseManager.saveTask(task: task, completion: {})
        }
        return result
    }
    
    // MARK: - Update
    
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
        if task.isComplete != oldTask.isComplete {
            realmManager.updateTaskIsComplete(taskID: task.taskID, isComplete: task.isComplete)
        }
        if task.isDeleted != oldTask.isDeleted {
            realmManager.updateTaskIsDeleted(taskID: task.taskID, isDeleted: task.isDeleted)
        }
        
        // Firebase更新
        if UserDefaultsKey.useFirebase.bool() && Network.isOnline() {
            firebaseManager.updateTask(task: task)
        }
    }
    
}

extension Array where Element: Equatable {
    typealias E = Element

    func subtracting(_ other: [E]) -> [E] {
        return self.compactMap { element in
            if (other.filter { $0 == element }).count == 0 {
                return element
            } else {
                return nil
            }
        }
    }

    mutating func subtract(_ other: [E]) {
        self = subtracting(other)
    }
}
