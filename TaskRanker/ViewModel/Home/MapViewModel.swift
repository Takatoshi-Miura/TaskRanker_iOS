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
    private var scatterChartData = ScatterChartData()
    
    // MARK: - DataSource
    
    /// Taskを取得
    private func getTaskData() {
        let taskManager = TaskManager()
        taskArray = taskManager.getTask()
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
