//
//  Task.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2022/10/14.
//

import RealmSwift

struct Task {
    
    var taskID: String
    var userID: String
    var title: String
    var memo: String
    var color: Int
    var importance: Int
    var urgency: Int
    var deadlineDate: Date?
    var daysBeforeUpdateUrgency: Int
    var completedDate: Date?
    var isComplete: Bool
    var isDeleted: Bool
    var created_at: Date
    var updated_at: Date
    
    var type: SegmentType {
        if importance > 4 && urgency > 4 {
            return SegmentType.A
        } else if importance > 4 && urgency <= 4 {
            return SegmentType.B
        } else if importance <= 4 && urgency > 4 {
            return SegmentType.C
        } else {
            return SegmentType.D
        }
    }
    
    init() {
        self.taskID = NSUUID().uuidString
        self.userID = UserDefaultsKey.userID.string()
        self.title = ""
        self.memo = ""
        self.color = TaskColor.red.rawValue
        self.importance = 4
        self.urgency = 4
        self.deadlineDate = nil
        self.daysBeforeUpdateUrgency = 0
        self.completedDate = nil
        self.isComplete = false
        self.isDeleted = false
        self.created_at = Date()
        self.updated_at = Date()
    }
    
    init(realmTask: RealmTask) {
        self.taskID = realmTask.taskID
        self.userID = realmTask.userID
        self.title = realmTask.title
        self.memo = realmTask.memo
        self.color = TaskColor.allCases[realmTask.color].rawValue
        self.importance = realmTask.importance
        self.urgency = realmTask.urgency
        self.deadlineDate = realmTask.deadlineDate
        self.daysBeforeUpdateUrgency = realmTask.daysBeforeUpdateUrgency
        self.completedDate = realmTask.completedDate
        self.isComplete = realmTask.isComplete
        self.isDeleted = realmTask.isDeleted
        self.created_at = realmTask.created_at
        self.updated_at = realmTask.updated_at
    }
    
}

/// Realm保存用
class RealmTask: Object {
    
    @objc dynamic var taskID: String = NSUUID().uuidString
    @objc dynamic var userID: String = UserDefaultsKey.userID.string()
    @objc dynamic var title: String = ""                // タイトル
    @objc dynamic var memo: String = ""                 // メモ
    @objc dynamic var color: Int = TaskColor.red.hashValue  // カラー
    @objc dynamic var importance: Int = 5               // 重要度
    @objc dynamic var urgency: Int = 5                  // 緊急度
    @objc dynamic var deadlineDate: Date?               // 期限日
    @objc dynamic var daysBeforeUpdateUrgency: Int = 0  // 緊急度引き上げ日
    @objc dynamic var completedDate: Date?              // 完了日
    @objc dynamic var isComplete: Bool = false          // 完了フラグ
    @objc dynamic var isDeleted: Bool = false           // 削除フラグ
    @objc dynamic var created_at: Date = Date()         // 作成日
    @objc dynamic var updated_at: Date = Date()         // 更新日
    
    // 主キー
    override static func primaryKey() -> String? {
        return "taskID"
    }
    
}
