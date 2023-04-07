//
//  MapViewModel.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2023/03/15.
//

import Charts

class MapViewModel {
    
    // MARK: - Variable
    
    private var taskArray = [Task]()
    private var selectedTask: Task?
    private var scatterChartData = ScatterChartData()
    
    // MARK: - Task
    
    /// Taskを取得
    private func getTaskData() {
        let taskManager = TaskManager()
        taskArray = taskManager.getTask()
    }
    
    /// 完了済み、削除済みTaskの判定
    /// - Returns: 判定結果
    func isDeletedTask() -> Bool {
        let taskManager = TaskManager()
        if let selectedTask = selectedTask {
            let updatedTask = taskManager.getTask(taskID: selectedTask.taskID)
            if updatedTask!.isDeleted || updatedTask!.isComplete {
                self.selectedTask = nil
                return true
            }
            self.selectedTask = nil
        }
        return false
    }
    
    /// 選択されたTaskを保存
    /// - Parameter task: Task
    func setSelectedTask(task: Task) {
        selectedTask = task
    }
    
    /// 選択されたTaskを保存
    /// - Parameter task: Task
    func getSelectedTask() -> Task? {
        return selectedTask
    }
    
    // MARK: - ScatterChartData
    
    /// ChartLimitLineを取得
    /// - Parameter limit: 座標
    /// - Returns: ChartLimitLine
    func getLimitLine(limit: Double) -> ChartLimitLine {
        let limitLine = ChartLimitLine(limit: limit, label: "")
        limitLine.lineWidth = 1.0
        limitLine.lineColor = .systemGray
        return limitLine
    }
    
    /// 散布図のデータを返す
    /// - Returns: 散布図データ
    func loadChartData() -> ScatterChartData {
        getTaskData()
        scatterChartData = ScatterChartData()
        for task in taskArray {
            let entry = ChartDataEntry(x: Double(task.urgency), y: Double(task.importance))
            let dataSet = ScatterChartDataSet(entries: [entry], label: task.taskID)
            dataSet.setScatterShape(.circle)
            dataSet.scatterShapeSize = 15.0
            dataSet.setColor(TaskColor.allCases[task.color].color)
            scatterChartData.append(dataSet)
        }
        scatterChartData.setDrawValues(false)
        return scatterChartData
    }
    
    /// タップされたTaskを取得
    /// - Parameter highlight: インデックス
    /// - Returns: Task（存在しない場合はnil）
    func getTapedTask(highlight: Highlight) -> Task? {
        let dataSet = scatterChartData[highlight.dataSetIndex]
        if let taskID = dataSet.label {
            let taskManager = TaskManager()
            let task = taskManager.getTask(taskID: taskID)
            return task
        }
        return nil
    }
    
}
