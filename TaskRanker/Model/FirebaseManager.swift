//
//  FirebaseManager.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2023/02/23.
//

import Firebase

class FirebaseManager {
    
    // MARK: - Variable
    
    var taskArray = [Task]()
    
    // MARK: - Create
    
    /// Taskを保存
    /// - Parameters:
    ///   - task: Task
    ///   - completion: 完了処理
    func saveTask(task: Task, completion: @escaping () -> ()) {
        let db = Firestore.firestore()
        db.collection("Task").document("\(task.userID)_\(task.taskID)").setData([
            "userID"                    : task.userID,
            "taskID"                    : task.taskID,
            "title"                     : task.title,
            "memo"                      : task.memo,
            "color"                     : task.color,
            "importance"                : task.importance,
            "urgency"                   : task.urgency,
            "deadlineDate"              : task.deadlineDate ?? "",
            "daysBeforeUpdateUrgency"   : task.daysBeforeUpdateUrgency,
            "completedDate"             : task.completedDate ?? "",
            "isComplete"                : task.isComplete,
            "isDeleted"                 : task.isDeleted,
            "created_at"                : task.created_at,
            "updated_at"                : task.updated_at
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                completion()
            }
        }
    }
    
    // MARK: - Select
    
    /// Taskを全取得
    /// - Parameters:
    ///   - completion: 完了処理
    func getAllTask(completion: @escaping () -> ()) {
        let db = Firestore.firestore()
        let userID = UserDefaults.standard.object(forKey: "userID") as! String
        db.collection("Task").whereField("userID", isEqualTo: userID).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.taskArray = []
                for document in querySnapshot!.documents {
                    let collection = document.data()
                    var task = Task()
                    task.userID = collection["userID"] as! String
                    task.taskID = collection["taskID"] as! String
                    task.title = collection["title"] as! String
                    task.memo = collection["memo"] as! String
                    task.color = collection["color"] as! TaskColor
                    task.importance = collection["importance"] as! Int
                    task.urgency = collection["urgency"] as! Int
                    task.deadlineDate = (collection["deadlineDate"] as! Timestamp).dateValue()
                    task.daysBeforeUpdateUrgency = collection["daysBeforeUpdateUrgency"] as! Int
                    task.completedDate = (collection["completedDate"] as! Timestamp).dateValue()
                    task.isComplete = collection["isComplete"] as! Bool
                    task.isDeleted = collection["isDeleted"] as! Bool
                    task.created_at = (collection["created_at"] as! Timestamp).dateValue()
                    task.updated_at = (collection["updated_at"] as! Timestamp).dateValue()
                    self.taskArray.append(task)
                }
                completion()
            }
        }
    }
    
    // MARK: - Update
    
    /// Taskを更新
    /// - Parameters:
    ///   - task: Task
    func updateTask(task: Task) {
        let db = Firestore.firestore()
        let database = db.collection("Task").document("\(task.userID)_\(task.taskID)")
        database.updateData([
            "title"                     : task.title,
            "memo"                      : task.memo,
            "color"                     : task.color,
            "importance"                : task.importance,
            "urgency"                   : task.urgency,
            "deadlineDate"              : task.deadlineDate ?? "",
            "daysBeforeUpdateUrgency"   : task.daysBeforeUpdateUrgency,
            "completedDate"             : task.completedDate ?? "",
            "isComplete"                : task.isComplete,
            "isDeleted"                 : task.isDeleted,
            "updated_at"                : task.updated_at
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            }
        }
    }
    
}
