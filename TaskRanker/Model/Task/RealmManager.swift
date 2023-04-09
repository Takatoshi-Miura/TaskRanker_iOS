//
//  RealmManager.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2022/10/14.
//

import RealmSwift

// MARK: - Common

class RealmManager {
    
    /// Realmにデータを作成
    /// - Parameter object: Realmオブジェクト
    /// - Returns: 成功失敗
    func createRealm(object: Object) -> Bool {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(object)
            }
        } catch {
            return false
        }
        return true
    }
    
    /// Realmにデータを作成(既に存在するオブジェクトはUpdate)
    /// - Parameter object: Realmオブジェクト
    /// - Returns: 成功失敗
    func createRealmWithUpdate(objects: [Object]) -> Bool {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(objects, update: .modified)
            }
        } catch {
            return false
        }
        return true
    }
    
    /// RealmのデータのUserIDを一括変更
    /// - Parameter userID: ユーザーID
    func updateAllRealmUserID(userID: String) {
        updateTaskUserID(userID: userID)
    }
    
    /// Realmのデータを全削除
    func deleteAllRealmData() {
        deleteAllTask()
    }
    
}

// MARK: - Task

extension RealmManager {
    
    // MARK: - Select
    
    /// RealmTaskを全取得
    /// - Returns: 全RealmTaskデータ
    func getAllTask() -> [RealmTask] {
        var taskArray = [RealmTask]()
        let realm = try! Realm()
        let realmArray = realm.objects(RealmTask.self)
            .filter("(isDeleted == false)")
        for task in realmArray {
            taskArray.append(task)
        }
        return taskArray
    }
    
    /// 未完了のRealmTaskを全取得
    /// - Returns: 未完了のRealmTaskデータ
    func getIncompleteTask() -> [RealmTask] {
        var taskArray = [RealmTask]()
        let realm = try! Realm()
        let realmArray = realm.objects(RealmTask.self)
            .filter("(isDeleted == false)")
            .filter("(isComplete == false)")
        for task in realmArray {
            taskArray.append(task)
        }
        return taskArray
    }
    
    /// 未完了のRealmTaskを全取得
    /// - Parameter filterArray: カラーBool配列
    /// - Returns: 未完了のRealmTaskデータ
    func getIncompleteTask(filterArray: [Bool]) -> [RealmTask] {
        var taskArray = [RealmTask]()
        let realm = try! Realm()
        let realmArray = realm.objects(RealmTask.self)
            .filter("(isDeleted == false)")
            .filter("(isComplete == false)")
        
        // カラー番号を取得
        var colorArray = [Int]()
        var index = 0
        for filter in filterArray {
            if filter {
                colorArray.append(index)
            }
            index += 1
        }
        
        // フィルタカラーに合致するTaskのみ取得
        for task in realmArray {
            if colorArray.contains(task.color) {
                taskArray.append(task)
            }
        }
        return taskArray
    }
    
    /// 完了済みのRealmTaskを全取得
    /// - Returns: 完了済みのRealmTaskデータ(完了日順)
    func getCompleteTask() -> [RealmTask] {
        var taskArray = [RealmTask]()
        let realm = try! Realm()
        let sortProperties = [
            SortDescriptor(keyPath: "completedDate", ascending: false),
        ]
        let realmArray = realm.objects(RealmTask.self)
            .filter("(isDeleted == false)")
            .filter("(isComplete == true)")
            .sorted(by: sortProperties)
        for task in realmArray {
            taskArray.append(task)
        }
        return taskArray
    }
    
    /// 期限日設定のあるRealmTaskを取得
    /// - Returns: RealmTask配列
    func getTaskWithDeadline() -> [RealmTask] {
        var taskArray = [RealmTask]()
        let realm = try! Realm()
        let realmArray = realm.objects(RealmTask.self)
            .filter("(deadlineDate != nil)")
            .filter("(isDeleted == false)")
            .filter("(isComplete == false)")
        for task in realmArray {
            taskArray.append(task)
        }
        return taskArray
    }
    
    /// RealmTaskを取得
    /// - Parameter taskID: taskID
    /// - Returns: RealmTaskデータ(存在しなければnil)
    func getTask(taskID: String) -> RealmTask? {
        let realm = try! Realm()
        let result = realm.objects(RealmTask.self)
            .filter("taskID == '\(taskID)'")
            .first
        return result
    }
    
    /// 指定日まで期限日のRealmTaskを取得
    /// - Parameter afterDays: 何日後か
    /// - Returns: RealmTask
    func getTask(afterDays: Int) -> [RealmTask] {
        var taskArray = [RealmTask]()
        let today = Date()
        let daysAfterNow = Calendar.current.date(byAdding: .day, value: afterDays, to: today)!
        let realm = try! Realm()
        let realmArray = realm.objects(RealmTask.self)
            .filter("deadlineDate > %@", today)
            .filter("deadlineDate < %@", daysAfterNow)
            .filter("(isDeleted == false)")
            .filter("(isComplete == false)")
        for task in realmArray {
            taskArray.append(task)
        }
        return taskArray
    }
    
    /// 期限切れのRealmTaskを取得
    /// - Returns: RealmTask
    func getExpiredTask() -> [RealmTask] {
        var taskArray = [RealmTask]()
        let today = Date()
        let realm = try! Realm()
        let realmArray = realm.objects(RealmTask.self)
            .filter("deadlineDate < %@", today)
            .filter("(isDeleted == false)")
            .filter("(isComplete == false)")
        for task in realmArray {
            taskArray.append(task)
        }
        return taskArray
    }
    
    // MARK: - Update
    
    /// 全RealmTaskのユーザーIDを更新
    /// - Parameter userID: ユーザーID
    func updateTaskUserID(userID: String) {
        let realm = try! Realm()
        let result = realm.objects(RealmTask.self)
        for task in result {
            try! realm.write {
                task.userID = userID
            }
        }
    }
    
    /// RealmTaskのタイトルを更新
    /// - Parameters:
    ///    - taskID: taskID
    ///    - title: タイトル
    func updateTaskTitle(taskID: String, title: String) {
        let realm = try! Realm()
        let result = realm.objects(RealmTask.self)
            .filter("taskID == '\(taskID)'").first
        try! realm.write {
            result?.title = title
            result?.updated_at = Date()
        }
    }
    
    /// RealmTaskのメモを更新
    /// - Parameters:
    ///    - taskID: taskID
    ///    - memo: メモ
    func updateTaskMemo(taskID: String, memo: String) {
        let realm = try! Realm()
        let result = realm.objects(RealmTask.self)
            .filter("taskID == '\(taskID)'").first
        try! realm.write {
            result?.memo = memo
            result?.updated_at = Date()
        }
    }
    
    /// RealmTaskのカラーを更新
    /// - Parameters:
    ///    - taskID: taskID
    ///    - color: カラー
    func updateTaskColor(taskID: String, color: Int) {
        let realm = try! Realm()
        let result = realm.objects(RealmTask.self)
            .filter("taskID == '\(taskID)'").first
        try! realm.write {
            result?.color = color
            result?.updated_at = Date()
        }
    }
    
    /// RealmTaskの重要度を更新
    /// - Parameters:
    ///    - taskID: taskID
    ///    - importance: 重要度
    func updateTaskImportance(taskID: String, importance: Int) {
        let realm = try! Realm()
        let result = realm.objects(RealmTask.self)
            .filter("taskID == '\(taskID)'").first
        try! realm.write {
            result?.importance = importance
            result?.updated_at = Date()
        }
    }
    
    /// RealmTaskの緊急度を更新
    /// - Parameters:
    ///    - taskID: taskID
    ///    - urgency: 緊急度
    func updateTaskUrgency(taskID: String, urgency: Int) {
        let realm = try! Realm()
        let result = realm.objects(RealmTask.self)
            .filter("taskID == '\(taskID)'").first
        try! realm.write {
            result?.urgency = urgency
            result?.updated_at = Date()
        }
    }
    
    /// RealmTaskの期限日を更新
    /// - Parameters:
    ///    - taskID: taskID
    ///    - deadlineDate: 期限日
    func updateTaskDeadlineDate(taskID: String, deadlineDate: Date?) {
        let realm = try! Realm()
        let result = realm.objects(RealmTask.self)
            .filter("taskID == '\(taskID)'").first
        try! realm.write {
            result?.deadlineDate = deadlineDate
            result?.updated_at = Date()
        }
    }
    
    /// RealmTaskの緊急度引き上げ日を更新
    /// - Parameters:
    ///    - taskID: taskID
    ///    - daysBeforeUpdateUrgency: 緊急度引き上げ日
    func updateTaskDaysBeforeUpdateUrgency(taskID: String, daysBeforeUpdateUrgency: Int) {
        let realm = try! Realm()
        let result = realm.objects(RealmTask.self)
            .filter("taskID == '\(taskID)'").first
        try! realm.write {
            result?.daysBeforeUpdateUrgency = daysBeforeUpdateUrgency
            result?.updated_at = Date()
        }
    }
    
    /// RealmTaskの完了日を更新
    /// - Parameters:
    ///    - taskID: taskID
    ///    - completedDate: 完了日
    func updateTaskCompletedDate(taskID: String, completedDate: Date?) {
        let realm = try! Realm()
        let result = realm.objects(RealmTask.self)
            .filter("taskID == '\(taskID)'").first
        try! realm.write {
            result?.completedDate = completedDate
            result?.updated_at = Date()
        }
    }
    
    /// RealmTaskの完了フラグを更新
    /// - Parameters:
    ///    - taskID: taskID
    ///    - isComplete: 完了フラグ
    func updateTaskIsComplete(taskID: String, isComplete: Bool) {
        let realm = try! Realm()
        let result = realm.objects(RealmTask.self)
            .filter("taskID == '\(taskID)'").first
        try! realm.write {
            result?.isComplete = isComplete
            result?.completedDate = Date()
            result?.updated_at = Date()
        }
    }
    
    /// RealmTaskの削除フラグを更新
    /// - Parameters:
    ///    - taskID: taskID
    ///    - isDeleted: 削除フラグ
    func updateTaskIsDeleted(taskID: String, isDeleted: Bool) {
        let realm = try! Realm()
        let result = realm.objects(RealmTask.self)
            .filter("taskID == '\(taskID)'").first
        try! realm.write {
            result?.isDeleted = isDeleted
            result?.updated_at = Date()
        }
    }
    
    // MARK: - Delete
    
    /// RealmTaskを全削除
    func deleteAllTask() {
        let realm = try! Realm()
        let tasks = realm.objects(RealmTask.self)
        do{
          try realm.write{
            realm.delete(tasks)
          }
        }catch {
          print("Error \(error)")
        }
    }
    
}
