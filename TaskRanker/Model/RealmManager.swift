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
    /// - Parameters:
    ///    - object: Realmオブジェクト
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
    /// - Parameters:
    ///    - object: Realmオブジェクト
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
    /// - Parameters:
    ///    - userID: ユーザーID
    func updateAllRealmUserID(userID: String) {
    }
    
    /// Realmのデータを全削除
    func deleteAllRealmData() {
    }
    
}

// MARK: - Task

extension RealmManager {
    
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
    
    /// RealmTaskを取得
    /// - Parameters:
    ///   - taskID: taskID
    /// - Returns: RealmTaskデータ(存在しなければnil)
    func getTask(taskID: String) -> RealmTask? {
        let realm = try! Realm()
        let result = realm.objects(RealmTask.self)
            .filter("taskID == '\(taskID)'")
            .first
        return result
    }
    
    /// 全RealmTaskのユーザーIDを更新
    /// - Parameters:
    ///   - userID: ユーザーID
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
    
    /// RealmTaskの緊急度自動引き上げフラグを更新
    /// - Parameters:
    ///    - taskID: taskID
    ///    - isUpdateUrgency: 緊急度自動引き上げフラグ
    func updateTaskIsUpdateUrgency(taskID: String, isUpdateUrgency: Bool) {
        let realm = try! Realm()
        let result = realm.objects(RealmTask.self)
            .filter("taskID == '\(taskID)'").first
        try! realm.write {
            result?.isUpdateUrgency = isUpdateUrgency
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
    
    /// RealmTaskの繰り返しフラグを更新
    /// - Parameters:
    ///    - taskID: taskID
    ///    - isRepeat: 繰り返しフラグ
    func updateTaskIsRepeat(taskID: String, isRepeat: Bool) {
        let realm = try! Realm()
        let result = realm.objects(RealmTask.self)
            .filter("taskID == '\(taskID)'").first
        try! realm.write {
            result?.isRepeat = isRepeat
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
