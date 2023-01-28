//
//  MapViewController.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2022/12/14.
//

import UIKit
import Charts

class MapViewController: UIViewController {
    
    @IBOutlet weak var scatterChartView: ScatterChartView!
    private var taskArray = [Task]()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureChartView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        displayChart()
    }
    
    // MARK: - ScatterChartView
    
    /// ChartViewの設定
    private func configureChartView () {
        // ズーム禁止
        scatterChartView.pinchZoomEnabled = false
        scatterChartView.doubleTapToZoomEnabled = false
        // ラベル非表示
        scatterChartView.rightAxis.enabled = false
        scatterChartView.legend.enabled = false
        scatterChartView.xAxis.labelFont = UIFont.systemFont(ofSize: 0)
        scatterChartView.leftAxis.labelFont = UIFont.systemFont(ofSize: 0)
        // X軸
        scatterChartView.xAxis.axisMaximum = 10
        scatterChartView.xAxis.axisMinimum = 0
        scatterChartView.xAxis.labelCount = 1
        // Y軸
        scatterChartView.leftAxis.axisMaximum = 10
        scatterChartView.leftAxis.axisMinimum = 0
        scatterChartView.leftAxis.labelCount = 1
    }
    
    /// 散布図に描画
    private func displayChart() {
        let taskManager = TaskManager()
        taskArray = taskManager.getTask()
        
        var entries = [BarChartDataEntry]()
        for task in taskArray {
            let entry = BarChartDataEntry(x: Double(task.urgency), y: Double(task.importance))
            entries.append(entry)
        }
        let set = ScatterChartDataSet(entries: entries, label: "Data")
        scatterChartView.data = ScatterChartData(dataSet: set)
    }

}
