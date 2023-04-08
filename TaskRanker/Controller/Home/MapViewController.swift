//
//  MapViewController.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2022/12/14.
//

import UIKit
import Charts
import GoogleMobileAds

protocol MapViewControllerDelegate: AnyObject {
    /// Taskタップ時
    func mapVCTaskDidTap(_ viewController: UIViewController, task: Task)
    /// キャラクタータップ時
    func mapVCCharacterDidTap(_ viewController: UIViewController)
}

class MapViewController: UIViewController {
    
    // MARK: - UI,Variable
    
    @IBOutlet weak var scatterChartView: ScatterChartView!
    @IBOutlet weak var urgencyLabel: UILabel!
    @IBOutlet weak var importanceLabel: UILabel!
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var characterMessageLabel: UILabel!
    @IBOutlet weak var adView: UIView!
    private var adMobView: GADBannerView?
    private var mapViewModel = MapViewModel()
    private var timer: Timer?
    var delegate: MapViewControllerDelegate?
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigationBar()
        initView()
        initCharacterView()
        initGestureRecognizer()
        initNotification()
        initChartView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        showAdMob()
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
    
    /// 画面初期化
    private func initView() {
        urgencyLabel.text = TITLE_URGENCY
        importanceLabel.text = TITLE_IMPORTANCE
        importanceLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        importanceLabel.adjustsFontSizeToFitWidth = true
    }
    
    /// バナー広告を表示
    private func showAdMob() {
        if let adMobView = adMobView {
            adMobView.frame.size = CGSize(width: self.view.frame.width, height: adMobView.frame.height)
            return
        }
        adMobView = GADBannerView()
        adMobView = GADBannerView(adSize: GADAdSizeBanner)
//        adMobView!.adUnitID = "ca-app-pub-9630417275930781/6787558566" // 本番用
        adMobView!.adUnitID = "ca-app-pub-3940256099942544/2934735716" // テスト用
        adMobView!.rootViewController = self
        adMobView!.load(GADRequest())
        adMobView!.frame.origin = CGPoint(x: 0, y: 0)
        adMobView!.frame.size = CGSize(width: self.view.frame.width, height: adMobView!.frame.height)
        adView.addSubview(adMobView!)
    }
    
    // MARK: - ScatterChartView
    
    /// ChartView初期化
    private func initChartView () {
        scatterChartView.delegate = self
        // ズーム禁止
        scatterChartView.pinchZoomEnabled = false
        scatterChartView.doubleTapToZoomEnabled = false
        // 凡例非表示
        scatterChartView.legend.enabled = false
        // X軸表示
        scatterChartView.xAxis.enabled = true
        scatterChartView.xAxis.axisMaximum = 9
        scatterChartView.xAxis.axisMinimum = 0
        scatterChartView.xAxis.labelFont = UIFont.systemFont(ofSize: 15)
        scatterChartView.xAxis.setLabelCount(10, force: true)
        scatterChartView.xAxis.addLimitLine(mapViewModel.getLimitLine(limit: 0.0))
        scatterChartView.xAxis.addLimitLine(mapViewModel.getLimitLine(limit: 4.5))
        scatterChartView.xAxis.addLimitLine(mapViewModel.getLimitLine(limit: 9.0))
        // Y軸表示
        scatterChartView.leftAxis.enabled = true
        scatterChartView.leftAxis.axisMaximum = 9
        scatterChartView.leftAxis.axisMinimum = 0
        scatterChartView.leftAxis.labelFont = UIFont.systemFont(ofSize: 15)
        scatterChartView.leftAxis.setLabelCount(10, force: true)
        scatterChartView.leftAxis.addLimitLine(mapViewModel.getLimitLine(limit: 0.0))
        scatterChartView.leftAxis.addLimitLine(mapViewModel.getLimitLine(limit: 4.5))
        scatterChartView.leftAxis.addLimitLine(mapViewModel.getLimitLine(limit: 9.0))
        scatterChartView.rightAxis.enabled = false
        scatterChartView.rightAxis.labelFont = UIFont.systemFont(ofSize: 0)
    }
    
    /// 散布図に描画
    private func displayChart() {
        scatterChartView.data = mapViewModel.loadChartData()
    }
    
    // MARK: - Character
    
    /// キャラクターの初期化
    @objc private func initCharacterView() {
        changeEventMessage(type: EventMessage.map)
        stopTimer()
        startTimer()
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
    
    // MARK: - UIGestureRecognizer
    
    /// ジャスチャ設定
    private func initGestureRecognizer() {
        addTapGesture()
    }
    
    /// キャラクタータップでキャラクター設定へ遷移
    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapCharacterView))
        characterImageView.addGestureRecognizer(tapGesture)
        characterImageView.isUserInteractionEnabled = true
    }
    
    /// タップ
    @objc private func tapCharacterView() {
        delegate?.mapVCCharacterDidTap(self)
    }
    
    // MARK: - Notification
    
    /// 通知設定
    private func initNotification() {
        // キャラクター変更時
        NotificationCenter.default.addObserver(self, selector: #selector(initCharacterView), name: NSNotification.Name(rawValue: "afterChangeCharacter"), object: nil)
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
