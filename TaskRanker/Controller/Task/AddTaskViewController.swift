//
//  AddTaskViewController.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2022/09/11.
//

import UIKit

protocol AddTaskViewControllerDelegate: AnyObject {
    /// モーダルを閉じる
    func addTaskVCDismiss(_ viewController: UIViewController)
    // 課題追加時の処理
    func addTaskVCAddTask(_ viewController: UIViewController, task: Task)
}

class AddTaskViewController: UIViewController {
    
    // MARK: - UI,Variable
    
    @IBOutlet weak var naviItem: UINavigationItem!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var memoLabel: UILabel!
    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var colorButton: UIButton!
    @IBOutlet weak var importanceLabel: UILabel!
    @IBOutlet weak var importanceValueLabel: UILabel!
    @IBOutlet weak var urgencyLabel: UILabel!
    @IBOutlet weak var urgencyValueLabel: UILabel!
    @IBOutlet weak var deadlineDateLabel: UILabel!
    @IBOutlet weak var deadlineDateButton: UIButton!
    @IBOutlet weak var repeatLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    private var pickerView = UIView()
    private let colorPicker = UIPickerView()
    private var datePicker = UIDatePicker()
    private var colorIndex: Int = 0
    private var selectedDate = Date()
    var delegate: AddTaskViewControllerDelegate?

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initDatePicker()
        initColorPicker()
        titleTextField.becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // マルチタスクビュー対策
        datePicker.frame.size.width = self.view.bounds.size.width
        colorPicker.frame.size.width = self.view.bounds.size.width
    }
    
    /// 画面初期化
    private func initView() {
        naviItem.title = TITLE_ADD_TASK
        titleLabel.text = TITLE_TITLE
        memoLabel.text = TITLE_MEMO
        colorLabel.text = TITLE_COLOR
        importanceLabel.text = TITLE_IMPORTANCE + TITLE_1to8
        urgencyLabel.text = TITLE_URGENCY + TITLE_1to8
        deadlineDateLabel.text = TITLE_DEADLINE_DATE
        repeatLabel.text = TITLE_REPEAT
        
        initTextField(textField: titleTextField, placeholder: "")
        initTextView(textView: memoTextView)
        
        colorButton.backgroundColor = Color.allCases[colorIndex].color
        colorButton.setTitle(Color.allCases[colorIndex].title, for: .normal)
        deadlineDateButton.setTitle(getDatePickerDate(datePicker: datePicker, format: "yyyy/M/d (E)"), for: .normal)
        cancelButton.setTitle(TITLE_CANCEL, for: .normal)
        saveButton.setTitle(TITLE_SAVE, for: .normal)
    }
    
    // MARK: - Action
    
    /// カラーボタン
    @IBAction func tapColorButton(_ sender: Any) {
        titleTextField.resignFirstResponder()
        closePicker(pickerView)
        pickerView = UIView(frame: colorPicker.bounds)
        pickerView.addSubview(colorPicker)
        pickerView.addSubview(createToolBar(#selector(colorPickerDoneAction), #selector(colorPickerCancelAction)))
        openPicker(pickerView)
    }
    
    /// 重要度スライダー
    @IBAction func slideImportanceSlider(_ sender: UISlider) {
        importanceValueLabel.text = String(Int(round(sender.value)))
    }
    
    /// 緊急度スライダー
    @IBAction func slideUrgencySlider(_ sender: UISlider) {
        urgencyValueLabel.text = String(Int(round(sender.value)))
    }
    
    /// 期限日ボタン
    @IBAction func tapDeadlineDateButton(_ sender: Any) {
        closePicker(pickerView)
        pickerView = UIView(frame: datePicker.bounds)
        pickerView.addSubview(datePicker)
        pickerView.addSubview(createToolBar(#selector(datePickerDoneAction), #selector(datePickerCancelAction)))
        openPicker(pickerView)
    }
    
    /// キャンセルボタン
    @IBAction func tapCancelButton(_ sender: Any) {
        // 入力済みの場合は確認アラート表示
        if !titleTextField.text!.isEmpty || !memoTextView.text.isEmpty {
            showOKCancelAlert(title: "", message: MESSAGE_DELETE_INPUT, OKAction: {
                self.delegate?.addTaskVCDismiss(self)
            })
            return
        }
        delegate?.addTaskVCDismiss(self)
    }
    
    /// 保存ボタン
    @IBAction func tapSaveButton(_ sender: Any) {
        // 入力チェック
        if titleTextField.text!.isEmpty {
            showErrorAlert(message: ERROR_MESSAGE_EMPTY_TITLE)
            return
        }
        
        // Taskを作成
        let realmManager = RealmManager()
        let realmTask = RealmTask()
        realmTask.title = titleTextField.text!
        realmTask.memo = memoTextView.text!
        realmTask.color = colorIndex
        realmTask.importance = Int(importanceValueLabel.text!)!
        realmTask.urgency = Int(urgencyValueLabel.text!)!
        // TODO: 期限日など
        
        if !realmManager.createRealm(object: realmTask) {
            showErrorAlert(message: "エラー")
            return
        }
        // TODO: Firebaseに送信(アカウント持ちの場合のみ)
        
        // モーダルを閉じる
        let taskManager = TaskManager()
        let task = taskManager.getTask(taskID: realmTask.taskID)!
        delegate?.addTaskVCAddTask(self, task: task)
    }
    
}

extension AddTaskViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    private enum PickerType: Int, CaseIterable {
        case color
        case date
    }
    
    /// 列数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch PickerType.allCases[pickerView.tag] {
        case .color:
            return 1
        case .date:
            return 3
        }
    }
    
    /// 項目数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch PickerType.allCases[pickerView.tag] {
        case .color:
            return Color.allCases.count
        case .date:
            return 1
        }
    }
    
    /// タイトル
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch PickerType.allCases[pickerView.tag] {
        case .color:
            return Color.allCases[row].title
        case .date:
            return nil
        }
    }
    
    /// DatePicker初期化
    private func initDatePicker() {
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ja")
        datePicker.tag = PickerType.date.rawValue
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.backgroundColor = UIColor.systemGray5
        datePicker.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: datePicker.bounds.size.height + 44)
        datePicker.date = Date()
    }
    
    /// DatePicker完了処理
    @objc func datePickerDoneAction() {
        selectedDate = datePicker.date
        deadlineDateButton.setTitle(getDatePickerDate(datePicker: datePicker, format: "yyyy/M/d (E)"), for: .normal)
        closePicker(pickerView)
    }
    
    /// DatePickerキャンセル処理
    @objc func datePickerCancelAction() {
        datePicker.date = selectedDate
        closePicker(pickerView)
    }
    
    /// ColorPicker初期化
    private func initColorPicker() {
        colorPicker.delegate = self
        colorPicker.dataSource = self
        colorPicker.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: colorPicker.bounds.size.height + 44)
        colorPicker.backgroundColor = UIColor.systemGray5
    }
    
    /// ColorPicker完了処理
    @objc func colorPickerDoneAction() {
        colorIndex = colorPicker.selectedRow(inComponent: 0)
        closePicker(pickerView)
        colorButton.backgroundColor = Color.allCases[colorIndex].color
        colorButton.setTitle(Color.allCases[colorIndex].title, for: .normal)
    }
    
    /// ColorPickerキャンセル処理
    @objc func colorPickerCancelAction() {
        colorPicker.selectRow(colorIndex, inComponent: 0, animated: false)
        closePicker(pickerView)
    }
    
}
