//
//  Task.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2022/10/14.
//

import RealmSwift

struct Task {
    
    let taskID: String
    let userID: String
    var title: String
    var memo: String
    var color: TaskColor
    var importance: Int
    var urgency: Int
    var deadlineDate: Date?
    var isUpdateUrgency: Bool
    var daysBeforeUpdateUrgency: Int
    var completedDate: Date?
    var isRepeat: Bool
    var isComplete: Bool
    var isDeleted: Bool
    let created_at: Date
    var updated_at: Date
    
    var type: SegmentType {
        if importance > 5 && urgency > 5 {
            return SegmentType.A
        } else if importance > 5 && urgency <= 5 {
            return SegmentType.B
        } else if importance <= 5 && urgency > 5 {
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
        self.color = TaskColor.red
        self.importance = 5
        self.urgency = 5
        self.deadlineDate = nil
        self.isUpdateUrgency = false
        self.daysBeforeUpdateUrgency = 0
        self.completedDate = nil
        self.isRepeat = false
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
        self.color = TaskColor.allCases[realmTask.color]
        self.importance = realmTask.importance
        self.urgency = realmTask.urgency
        self.deadlineDate = realmTask.deadlineDate
        self.isUpdateUrgency = realmTask.isUpdateUrgency
        self.daysBeforeUpdateUrgency = realmTask.daysBeforeUpdateUrgency
        self.completedDate = realmTask.completedDate
        self.isRepeat = realmTask.isRepeat
        self.isComplete = realmTask.isComplete
        self.isDeleted = realmTask.isDeleted
        self.created_at = realmTask.created_at
        self.updated_at = realmTask.updated_at
    }
    
}

/// Realm?????????
class RealmTask: Object {
    
    @objc dynamic var taskID: String = NSUUID().uuidString
    @objc dynamic var userID: String = UserDefaultsKey.userID.string()
    @objc dynamic var title: String = ""                // ????????????
    @objc dynamic var memo: String = ""                 // ??????
    @objc dynamic var color: Int = TaskColor.red.hashValue  // ?????????
    @objc dynamic var importance: Int = 5               // ?????????
    @objc dynamic var urgency: Int = 5                  // ?????????
    @objc dynamic var deadlineDate: Date?               // ?????????
    @objc dynamic var isUpdateUrgency: Bool = false     // ????????????????????????????????????
    @objc dynamic var daysBeforeUpdateUrgency: Int = 0  // ????????????????????????
    @objc dynamic var completedDate: Date?              // ?????????
    @objc dynamic var isRepeat: Bool = false            // ????????????
    @objc dynamic var isComplete: Bool = false          // ???????????????
    @objc dynamic var isDeleted: Bool = false           // ???????????????
    @objc dynamic var created_at: Date = Date()         // ?????????
    @objc dynamic var updated_at: Date = Date()         // ?????????
    
    // ?????????
    override static func primaryKey() -> String? {
        return "taskID"
    }
    
}
