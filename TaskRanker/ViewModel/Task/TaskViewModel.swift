//
//  TaskViewModel.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2023/04/03.
//

import UIKit

enum PickerType: Int, CaseIterable {
    case color
    case day
}

class TaskViewModel: NSObject {
    
    // MARK: - Variable
    
    var task: Task?
    var isViewer: Bool
    private var dayArray = [Int](1...99)
    
    
    // MARK: - Initializer
    
    init(task: Task?) {
        if let task = task {
            self.task = task
            self.isViewer = true
        } else {
            self.isViewer = false
        }
    }
    
    /// TaskTypeを取得
    /// - Parameters:
    ///   - importance: 重要度
    ///   - urgency: 緊急度
    /// - Returns: タイトル
    func getTaskType(importance: String, urgency: String) -> String {
        if Int(importance)! > 4 && Int(urgency)! > 4 {
            return TaskType.A.typeTitle
        } else if Int(importance)! > 4 && Int(urgency)! <= 4 {
            return TaskType.B.typeTitle
        } else if Int(importance)! <= 4 && Int(urgency)! > 4 {
            return TaskType.C.typeTitle
        } else {
            return TaskType.D.typeTitle
        }
    }
    
    // MARK: - Action
    
    /// Taskを完了にする
    func completeTask() {
        if task != nil {
            task!.isComplete = true
        }
    }
    
    /// Taskを削除
    func deleteTask() {
        if task != nil {
            task!.isDeleted = true
        }
    }
    
    /// Taskを保存(新規作成)
    /// - Parameter task: Task
    /// - Returns: 結果
    func saveTask(task: Task) -> Bool {
        let taskManager = TaskManager()
        return !taskManager.saveTask(task: task)
    }
    
    /// Taskを更新
    /// - Parameter task: Task
    func updateTask(task: Task) {
        if self.task != nil {
            self.task!.title = task.title
            self.task!.memo = task.memo
            self.task!.color = task.color
            self.task!.importance = task.importance
            self.task!.urgency = task.urgency
            self.task!.deadlineDate = task.deadlineDate
            self.task!.daysBeforeUpdateUrgency = task.daysBeforeUpdateUrgency
        }
    }
    
    
    
}

extension TaskViewModel: UIPickerViewDataSource {
    
    /// 列数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch PickerType.allCases[pickerView.tag] {
        case .color:
            return 1
        case .day:
            return 1
        }
    }
    
    /// 項目数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch PickerType.allCases[pickerView.tag] {
        case .color:
            return TaskColor.allCases.count
        case .day:
            return dayArray.count
        }
    }
    
    /// タイトル
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        switch PickerType.allCases[pickerView.tag] {
        case .color:
            let customView = UIView(frame: CGRect(x: 0, y: 0, width: 125, height: 30))
            let image = UIImage(systemName: "circle.fill")
            let imageView = UIImageView(image: image)
            imageView.tintColor = TaskColor.allCases[row].color
            imageView.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
            customView.addSubview(imageView)
            let label = UILabel(frame: CGRect(x: 30, y: 0, width: 100, height: 30))
            label.text = TaskColor.allCases[row].title
            label.textAlignment = .center
            customView.addSubview(label)
            return customView
        case .day:
            let label = UILabel()
            label.text = Converter.updateUrgencyString(day: dayArray[row])
            label.textAlignment = .center
            let stackView = UIStackView(arrangedSubviews: [label])
            stackView.axis = .horizontal
            stackView.alignment = .center
            return stackView
        }
    }
    
}
