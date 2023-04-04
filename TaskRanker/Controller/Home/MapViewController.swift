//
//  MapViewController.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2022/12/14.
//

import UIKit
import Charts

protocol MapViewControllerDelegate: AnyObject {
    /// Taskタップ時
    func mapVCTaskDidTap(_ viewController: UIViewController, task: Task)
}

class MapViewController: UIViewController {
    
    // MARK: - UI,Variable
    
    @IBOutlet weak var scatterChartView: ScatterChartView!
    private var mapViewModel = MapViewModel()
    var delegate: MapViewControllerDelegate?
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigationBar()
        configureChartView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        displayChart()
    }
    
    // MARK: - Viewer
    
    /// NavigationBar初期化
    private func initNavigationBar() {
        self.navigationItem.title = TITLE_TASK_LIST
    }
    
    // MARK: - ScatterChartView
    
    /// ChartViewの設定
    private func configureChartView () {
        scatterChartView.delegate = self
        // ズーム禁止
        scatterChartView.pinchZoomEnabled = false
        scatterChartView.doubleTapToZoomEnabled = false
        // ラベル非表示
        scatterChartView.rightAxis.enabled = false
        scatterChartView.legend.enabled = false
        scatterChartView.xAxis.labelFont = UIFont.systemFont(ofSize: 0)
        scatterChartView.leftAxis.labelFont = UIFont.systemFont(ofSize: 0)
        // X軸
        scatterChartView.xAxis.axisMaximum = 9
        scatterChartView.xAxis.axisMinimum = 0
        scatterChartView.xAxis.labelCount = 1
        // Y軸
        scatterChartView.leftAxis.axisMaximum = 9
        scatterChartView.leftAxis.axisMinimum = 0
        scatterChartView.leftAxis.labelCount = 1
        // デフォルト軸線を非表示
        scatterChartView.xAxis.drawGridLinesEnabled = false
        scatterChartView.leftAxis.drawGridLinesEnabled = false
        // 軸線
        var limitLine = ChartLimitLine(limit: 4.5, label: "")
        limitLine.lineWidth = 1.0
        limitLine.lineColor = .systemGray
        scatterChartView.xAxis.addLimitLine(limitLine)
        scatterChartView.leftAxis.addLimitLine(limitLine)
        
        limitLine = ChartLimitLine(limit: 9.0, label: "")
        limitLine.lineWidth = 1.0
        limitLine.lineColor = .systemGray
        scatterChartView.xAxis.addLimitLine(limitLine)
        scatterChartView.leftAxis.addLimitLine(limitLine)
        
        limitLine = ChartLimitLine(limit: 0, label: "")
        limitLine.lineWidth = 1.0
        limitLine.lineColor = .systemGray
        scatterChartView.xAxis.addLimitLine(limitLine)
        scatterChartView.leftAxis.addLimitLine(limitLine)
    }
    
    /// 散布図に描画
    private func displayChart() {
        scatterChartView.data = mapViewModel.loadChartData()
    }

}

extension MapViewController: ChartViewDelegate {
    
    /// データタップ時の処理
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        if let task = mapViewModel.getTapedTask(highlight: highlight) {
            self.delegate?.mapVCTaskDidTap(self, task: task)
        }
    }
    
}
