//
//  TaskViewController.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2022/10/23.
//

import UIKit

protocol TaskViewControllerDelegate: AnyObject {
    /// 画面を閉じる(タスク新規作成用)
    func taskVCDismiss(_ viewController: UIViewController)
    /// 画面を閉じる
    func taskVCDismiss(task: Task)
    /// タスク削除時の処理
    func taskVCDeleteTask(task: Task)
    /// タスク追加時の処理
    func taskVCAddTask(_ viewController: UIViewController, task: Task)
}

class TaskViewController: UIViewController {
    
    // MARK: - UI,Variable
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var memoLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var importanceLabel: UILabel!
    @IBOutlet weak var importanceSlider: UISlider!
    @IBOutlet weak var importanceValueLabel: UILabel!
    @IBOutlet weak var urgencyLabel: UILabel!
    @IBOutlet weak var urgencySlider: UISlider!
    @IBOutlet weak var urgencyValueLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var typeValueLabel: UILabel!
    @IBOutlet weak var deadlineDateLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var colorButton: UIButton!
    @IBOutlet weak var deadlineSwitch: UISwitch!
    @IBOutlet weak var deadlineDateButton: UIButton!
    
    private var pickerView = UIView()
    private let colorPicker = UIPickerView()
    private var datePicker = UIDatePicker()
    private var colorIndex: Int = 0
    private var selectedDate = Date()
    var task = Task()
    var isViewer = false
    var delegate: TaskViewControllerDelegate?
    
    // MARK: - Initializer
    
    /// イニシャライザ
    /// - Parameter task: nilの場合は新規作成
    init(task: Task?) {
        if let task = task {
            self.task = task
            self.isViewer = true
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initNavigationBar()
        initDatePicker()
        initColorPicker()
        if isViewer {
            inputTask()
        } else {
            titleTextField.becomeFirstResponder()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // マルチタスクビュー対策
        datePicker.frame.size.width = self.view.bounds.size.width
        colorPicker.frame.size.width = self.view.bounds.size.width
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isViewer {
            delegate?.taskVCDismiss(task: task)
        }
    }
    
    /// 画面初期化
    private func initView() {
        titleLabel.text = TITLE_TITLE
        memoLabel.text = TITLE_MEMO
        colorLabel.text = TITLE_COLOR
        importanceLabel.text = TITLE_IMPORTANCE + TITLE_1to8
        urgencyLabel.text = TITLE_URGENCY + TITLE_1to8
        typeLabel.text = TITLE_TASK_TYPE
        deadlineDateLabel.text = TITLE_DEADLINE_DATE
        
        initTextField(textField: titleTextField, placeholder: "")
        initTextView(textView: memoTextView)
        titleTextField.delegate = self
        memoTextView.delegate = self
        
        colorButton.backgroundColor = TaskColor.allCases[colorIndex].color
        colorButton.setTitle(TaskColor.allCases[colorIndex].title, for: .normal)
        setDeadlineSwitch(isOn: false)
    }
    
    /// NavigationBar初期化
    private func initNavigationBar() {
        // 閉じる
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close,
                                          target: self,
                                          action: #selector(tapCloseButton(_:)))
        
        // ゴミ箱
        let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash,
                                           target: self,
                                           action: #selector(deleteTask))
        deleteButton.tintColor = UIColor.red
        
        // 完了,未完了
        let image = task.isComplete ? UIImage(systemName: "exclamationmark.circle") : UIImage(systemName: "checkmark.circle")
        let completeButton = UIBarButtonItem(image: image,
                                             style: .done,
                                             target: self,
                                             action: #selector(completeTask))
        
        // 保存
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save,
                                         target: self,
                                         action: #selector(tapSaveButton(_:)))
        
        if isViewer {
            self.title = TITLE_EDIT
            navigationItem.rightBarButtonItems = [deleteButton, completeButton]
        } else {
            self.title = TITLE_ADD_TASK
            navigationItem.rightBarButtonItems = [saveButton]
            navigationItem.leftBarButtonItems = [closeButton]
        }
    }
    
    /// Taskの中身を反映
    private func inputTask() {
        titleTextField.text = task.title
        memoTextView.text = task.memo
        colorButton.backgroundColor = task.color.color
        colorButton.setTitle(task.color.title, for: .normal)
        importanceSlider.value = Float(task.importance)
        importanceValueLabel.text = String(task.importance)
        urgencySlider.value = Float(task.urgency)
        urgencyValueLabel.text = String(task.urgency)
        typeValueLabel.text = task.type.typeTitle
        if let date = task.deadlineDate {
            selectedDate = date
            setDeadlineSwitch(isOn: true)
        } else {
            setDeadlineSwitch(isOn: false)
        }
        datePicker.setDate(selectedDate, animated: false)
        deadlineDateButton.setTitle(getDateString(date: selectedDate), for: .normal)
    }
    
    // MARK: - Action
    
    /// 閉じるボタン
    @objc func tapCloseButton(_ sender: UIBarButtonItem) {
        // 入力済みの場合は確認アラート表示
        if !titleTextField.text!.isEmpty || !memoTextView.text.isEmpty {
            showOKCancelAlert(title: "", message: MESSAGE_DELETE_INPUT, OKAction: {
                self.delegate?.taskVCDismiss(self)
            })
            return
        }
        delegate?.taskVCDismiss(self)
    }
    
    /// タスクを削除
    @objc func deleteTask() {
        showDeleteAlert(title: TITLE_DELETE_TASK, message: MESSAGE_DELETE_TASK, OKAction: { [self] in
            self.task.isDeleted = true
            self.delegate?.taskVCDeleteTask(task: self.task)
        })
    }
    
    /// Taskを完了(未完了)にする
    @objc func completeTask() {
        let message = task.isComplete ? MESSAGE_INCOMPLETE_TASK : MESSAGE_COMPLETE_TASK
        showOKCancelAlert(title: TITLE_COMPLETE_TASK, message: message, OKAction: {
            self.task.isComplete = !self.task.isComplete
            self.delegate?.taskVCDeleteTask(task: self.task)
        })
    }
    
    /// 保存ボタン
    @objc func tapSaveButton(_ sender: UIBarButtonItem) {
        // 入力チェック
        if titleTextField.text!.isEmpty {
            showErrorAlert(message: ERROR_MESSAGE_EMPTY_TITLE)
            return
        }
        
        // Taskを作成
        var task = Task()
        task.title = titleTextField.text!
        task.memo = memoTextView.text!
        task.color = TaskColor.allCases[colorIndex]
        task.importance = Int(importanceValueLabel.text!)!
        task.urgency = Int(urgencyValueLabel.text!)!
        task.deadlineDate = deadlineSwitch.isOn ? selectedDate : nil
        
        let taskManager = TaskManager()
        if !taskManager.saveTask(task: task) {
            showErrorAlert(message: ERROR_MESSAGE_SAVE_FAILED)
            return
        }
        // TODO: Firebaseに送信(アカウント持ちの場合のみ)
        
        // モーダルを閉じる
        delegate?.taskVCAddTask(self, task: task)
    }
    
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
        let value = Int(round(sender.value))
        importanceValueLabel.text = String(value)
        task.importance = value
        typeValueLabel.text = task.type.typeTitle
    }
    
    /// 緊急度スライダー
    @IBAction func slideUrgencySlider(_ sender: UISlider) {
        let value = Int(round(sender.value))
        urgencyValueLabel.text = String(value)
        task.urgency = value
        typeValueLabel.text = task.type.typeTitle
    }
    
    /// 期限日スイッチ
    @IBAction func tapDeadlineSwitch(_ sender: UISwitch) {
        setDeadlineSwitch(isOn: sender.isOn)
    }
    
    /// 期限日スイッチの切替
    /// - Parameter isOn: ON or OFF
    private func setDeadlineSwitch(isOn :Bool) {
        deadlineSwitch.isOn = isOn
        deadlineDateButton.isHidden = deadlineSwitch.isOn ? false : true
        task.deadlineDate = deadlineSwitch.isOn ? selectedDate : nil
    }
    
    /// 期限日ボタン
    @IBAction func tapDeadlineDateButton(_ sender: Any) {
        closePicker(pickerView)
        pickerView = UIView(frame: datePicker.bounds)
        pickerView.addSubview(datePicker)
        pickerView.addSubview(createToolBar(#selector(datePickerDoneAction), #selector(datePickerCancelAction)))
        openPicker(pickerView)
    }
    
}

extension TaskViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
            return TaskColor.allCases.count
        case .date:
            return 1
        }
    }
    
    /// タイトル
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch PickerType.allCases[pickerView.tag] {
        case .color:
            return TaskColor.allCases[row].title
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
        deadlineDateButton.setTitle(getDateString(date: selectedDate), for: .normal)
        task.deadlineDate = selectedDate
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
        colorButton.backgroundColor = TaskColor.allCases[colorIndex].color
        colorButton.setTitle(TaskColor.allCases[colorIndex].title, for: .normal)
        task.color = TaskColor.allCases[colorIndex]
    }
    
    /// ColorPickerキャンセル処理
    @objc func colorPickerCancelAction() {
        colorPicker.selectRow(colorIndex, inComponent: 0, animated: false)
        closePicker(pickerView)
    }
    
}

extension TaskViewController: UITextFieldDelegate {

    /// フォーカスが外れる前
    /// - Parameter textField: 対象のテキストフィールド
    /// - Returns: trueでフォーカスを外す falseでフォーカスを外さない
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if !isViewer {
            return true
        }
        if textField.text == "" {
            showErrorAlert(message: ERROR_MESSAGE_EMPTY_TITLE)
            textField.text = task.title
            return false
        }
        task.title = textField.text!
        return true
    }
    
}

extension TaskViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if !isViewer {
            return
        }
        task.memo = textView.text
    }
    
}
