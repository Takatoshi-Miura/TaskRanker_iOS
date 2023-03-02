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
    
    let TABLE_TASK = "Task"
    let KEY_USER_ID = "userId"
    let KEY_TASK_ID = "taskID"
    let KEY_TITLE = "title"
    let KEY_MEMO = "memo"
    let KEY_COLOR = "color"
    let KEY_IMPORTANCE = "importance"
    let KEY_URGENCY = "urgency"
    let KEY_DEADLINE_DATE = "deadlineDate"
    let KEY_COMPLETED_DATE = "completedDate"
    let KEY_IS_COMPLETE = "isComplete"
    let KEY_IS_DELETED = "isDeleted"
    let KEY_CREATED_AT = "created_at"
    let KEY_UPDATED_AT = "updated_at"
    let KEY_DAYS_BEFORE_UPDATE_URGENCY = "daysBeforeUpdateUrgency"
    
    // MARK: - Create
    
    /// Taskを保存
    /// - Parameters:
    ///   - task: Task
    ///   - completion: 完了処理
    func saveTask(task: Task, completion: @escaping () -> ()) {
        var taskDic = [String : Any]()
        taskDic[KEY_USER_ID] = task.userID
        taskDic[KEY_TASK_ID] = task.taskID
        taskDic[KEY_TITLE] = task.title
        taskDic[KEY_MEMO] = task.memo
        taskDic[KEY_COLOR] = task.color
        taskDic[KEY_IMPORTANCE] = task.importance
        taskDic[KEY_URGENCY] = task.urgency
        taskDic[KEY_DAYS_BEFORE_UPDATE_URGENCY] = task.daysBeforeUpdateUrgency
        taskDic[KEY_IS_COMPLETE] = task.isComplete
        taskDic[KEY_IS_DELETED] = task.isDeleted
        taskDic[KEY_CREATED_AT] = task.created_at
        taskDic[KEY_UPDATED_AT] = task.updated_at
        if let deadlineDate = task.deadlineDate {
            taskDic[KEY_DEADLINE_DATE] = deadlineDate
        }
        if let completedDate = task.completedDate {
            taskDic[KEY_COMPLETED_DATE] = completedDate
        }
        
        let db = Firestore.firestore()
        db.collection(TABLE_TASK).document("\(task.userID)_\(task.taskID)").setData(taskDic) { err in
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
        let userID = UserDefaultsKey.userID.string()
        db.collection(TABLE_TASK).whereField(KEY_USER_ID, isEqualTo: userID).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.taskArray = []
                for document in querySnapshot!.documents {
                    let collection = document.data()
                    var task = Task()
                    task.userID = collection[self.KEY_USER_ID] as! String
                    task.taskID = collection[self.KEY_TASK_ID] as! String
                    task.title = collection[self.KEY_TITLE] as! String
                    task.memo = collection[self.KEY_MEMO] as! String
                    task.color = collection[self.KEY_COLOR] as! Int
                    task.importance = collection[self.KEY_IMPORTANCE] as! Int
                    task.urgency = collection[self.KEY_URGENCY] as! Int
                    task.daysBeforeUpdateUrgency = collection[self.KEY_DAYS_BEFORE_UPDATE_URGENCY] as! Int
                    task.isComplete = collection[self.KEY_IS_COMPLETE] as! Bool
                    task.isDeleted = collection[self.KEY_IS_DELETED] as! Bool
                    task.created_at = (collection[self.KEY_CREATED_AT] as! Timestamp).dateValue()
                    task.updated_at = (collection[self.KEY_UPDATED_AT] as! Timestamp).dateValue()
                    if let deadlineDate = collection[self.KEY_DEADLINE_DATE] {
                        task.deadlineDate = (deadlineDate as! Timestamp).dateValue()
                    }
                    if let completedDate = collection[self.KEY_COMPLETED_DATE] {
                        task.completedDate = (completedDate as! Timestamp).dateValue()
                    }
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
        var taskDic = [String : Any]()
        taskDic[KEY_TITLE] = task.title
        taskDic[KEY_MEMO] = task.memo
        taskDic[KEY_COLOR] = task.color
        taskDic[KEY_IMPORTANCE] = task.importance
        taskDic[KEY_URGENCY] = task.urgency
        taskDic[KEY_DAYS_BEFORE_UPDATE_URGENCY] = task.daysBeforeUpdateUrgency
        taskDic[KEY_IS_COMPLETE] = task.isComplete
        taskDic[KEY_IS_DELETED] = task.isDeleted
        taskDic[KEY_UPDATED_AT] = task.updated_at
        if let deadlineDate = task.deadlineDate {
            taskDic[KEY_DEADLINE_DATE] = deadlineDate
        }
        if let completedDate = task.completedDate {
            taskDic[KEY_COMPLETED_DATE] = completedDate
        }
        
        let db = Firestore.firestore()
        let database = db.collection(TABLE_TASK).document("\(task.userID)_\(task.taskID)")
        database.updateData(taskDic) { err in
            if let err = err {
                print("Error updating document: \(err)")
            }
        }
    }
    
}
