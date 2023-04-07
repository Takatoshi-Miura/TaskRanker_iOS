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
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var characterMessageLabel: UILabel!
    @IBOutlet weak var adView: UIView!
    private var mapViewModel = MapViewModel()
    private var timer: Timer?
    var delegate: MapViewControllerDelegate?
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigationBar()
        initCharacterView()
        initChartView()
        startTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // メッセージ更新
        if mapViewModel.getSelectedTask() != nil {
            if mapViewModel.isDeletedTask() {
                scatterChartView.highlightValue(nil)
                changeEventMessage(type: EventMessage.complete)
            } else {
                changeEventMessage(type: EventMessage.update)
            }
            startTimer()
        }
        displayChart()
    }
    
    // MARK: - Viewer
    
    /// NavigationBar初期化
    private func initNavigationBar() {
        self.navigationItem.title = TITLE_TASK_LIST
    }
    
    // MARK: - ScatterChartView
    
    /// ChartView初期化
    private func initChartView () {
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
        // デフォルトの枠線を非表示
        scatterChartView.xAxis.drawGridLinesEnabled = false
        scatterChartView.leftAxis.drawGridLinesEnabled = false
        // 枠線追加
        scatterChartView.xAxis.addLimitLine(mapViewModel.getLimitLine(limit: 0.0))
        scatterChartView.xAxis.addLimitLine(mapViewModel.getLimitLine(limit: 4.5))
        scatterChartView.xAxis.addLimitLine(mapViewModel.getLimitLine(limit: 9.0))
        scatterChartView.leftAxis.addLimitLine(mapViewModel.getLimitLine(limit: 0.0))
        scatterChartView.leftAxis.addLimitLine(mapViewModel.getLimitLine(limit: 4.5))
        scatterChartView.leftAxis.addLimitLine(mapViewModel.getLimitLine(limit: 9.0))
    }
    
    /// 散布図に描画
    private func displayChart() {
        scatterChartView.data = mapViewModel.loadChartData()
    }
    
    // MARK: - Character
    
    /// キャラクターの初期化
    @objc private func initCharacterView() {
        changeEventMessage(type: EventMessage.map)
    }
    
    /// キャラクターの画像とメッセージを変更
    /// - Parameter type: タイプ
    private func changeEventMessage(type: EventMessage) {
        characterImageView.image = type.image
        Util.animateLabel(label: characterMessageLabel, text: type.message)
    }
    
    /// キャラクターの画像とメッセージを変更
    /// - Parameter type: タイプ
    private func changeRandomMessage(type: RandomMessage) {
        characterImageView.image = type.image
        Util.animateLabel(label: characterMessageLabel, text: type.message)
    }
    
    // MARK: - Timer
    
    /// タイマー開始
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(updateCharacterMessage), userInfo: nil, repeats: true)
    }
    
    /// タイマー停止
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    /// キャラクターのコメントを更新
    @objc private func updateCharacterMessage() {
        let messageType = RandomMessage.allCases.randomElement()
        changeRandomMessage(type: messageType!)
    }

}

extension MapViewController: ChartViewDelegate {
    
    /// データタップ時の処理
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        if let task = mapViewModel.getTapedTask(highlight: highlight) {
            self.stopTimer()
            self.mapViewModel.setSelectedTask(task: task)
            self.delegate?.mapVCTaskDidTap(self, task: task)
        }
    }
    
}
