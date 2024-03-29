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
    @IBOutlet weak var updateUrgencyLabel: UILabel!
    @IBOutlet weak var updateUrgencyButton: UIButton!
    
    private var pickerView = UIView()
    private let colorPicker = UIPickerView()
    private let dayPicker = UIPickerView()
    private var datePicker = UIDatePicker()
    private var selectedColor = 0
    private var selectedDay = 2
    private var selectedDate = Converter.getDaysAfterDate(date: Date(), daysAfter: 7)
    private var dayArray = [Int](1...99)
    private var taskViewModel: TaskViewModel
    var delegate: TaskViewControllerDelegate?
    
    // MARK: - Initializer
    
    /// イニシャライザ
    /// - Parameter task: nilの場合は新規作成
    init(task: Task?) {
        taskViewModel = TaskViewModel(task: task)
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
        initDayPicker()
        if !taskViewModel.isViewer {
            titleTextField.becomeFirstResponder()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // マルチタスクビュー対策
        datePicker.frame.size.width = self.view.bounds.size.width
        colorPicker.frame.size.width = self.view.bounds.size.width
        dayPicker.frame.size.width = self.view.bounds.size.width
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if taskViewModel.isViewer {
            taskViewModel.updateTask(task: applyTask())
            delegate?.taskVCDismiss(task: taskViewModel.task!)
        }
    }
    
    // MARK: - Viewer
    
    /// 画面初期化
    private func initView() {
        // ラベル
        titleLabel.text = TITLE_TITLE
        memoLabel.text = TITLE_MEMO
        colorLabel.text = TITLE_COLOR
        importanceLabel.text = TITLE_IMPORTANCE + TITLE_1to8
        urgencyLabel.text = TITLE_URGENCY + TITLE_1to8
        typeLabel.text = TITLE_TASK_TYPE
        deadlineDateLabel.text = TITLE_DEADLINE_DATE
        updateUrgencyLabel.text = TITLE_UPDATE_URGENCY
        // テキスト
        initTextField(textField: titleTextField, placeholder: "")
        initTextView(textView: memoTextView)
        titleTextField.delegate = self
        // ボタン
        colorButton.backgroundColor = TaskColor.allCases[selectedColor].color
        colorButton.setTitle(TaskColor.allCases[selectedColor].title, for: .normal)
        deadlineDateButton.setTitle(Converter.dateToString(date: selectedDate), for: .normal)
        updateUrgencyButton.setTitle(Converter.updateUrgencyString(day: dayArray[selectedDay]), for: .normal)
        
        if taskViewModel.isViewer {
            inputTask()
        } else {
            setDeadlineSwitch(isOn: true)
        }
    }
    
    /// Taskの中身を反映
    private func inputTask() {
        titleTextField.text = taskViewModel.task!.title
        memoTextView.text = taskViewModel.task!.memo
        selectedColor = taskViewModel.task!.color
        colorButton.backgroundColor = TaskColor.allCases[selectedColor].color
        colorButton.setTitle(TaskColor.allCases[selectedColor].title, for: .normal)
        importanceSlider.value = Float(taskViewModel.task!.importance)
        importanceValueLabel.text = String(taskViewModel.task!.importance)
        urgencySlider.value = Float(taskViewModel.task!.urgency)
        urgencyValueLabel.text = String(taskViewModel.task!.urgency)
        typeValueLabel.text = taskViewModel.task!.type.typeTitle
        selectedDay = taskViewModel.task!.daysBeforeUpdateUrgency - 1
        updateUrgencyButton.setTitle(Converter.updateUrgencyString(day: dayArray[selectedDay]), for: .normal)
        
        if let date = taskViewModel.task!.deadlineDate {
            selectedDate = date
            datePicker.setDate(selectedDate, animated: false)
            deadlineDateButton.setTitle(Converter.dateToString(date: selectedDate), for: .normal)
            setDeadlineSwitch(isOn: true)
        } else {
            setDeadlineSwitch(isOn: false)
        }
    }
    
    /// 入力内容をTaskに反映
    /// - Returns: Task
    private func applyTask() -> Task {
        var task = Task()
        task.title = titleTextField.text!
        task.memo = memoTextView.text!
        task.color = TaskColor.allCases[selectedColor].rawValue
        task.importance = Int(importanceValueLabel.text!)!
        task.urgency = Int(urgencyValueLabel.text!)!
        task.deadlineDate = deadlineSwitch.isOn ? selectedDate : nil
        task.daysBeforeUpdateUrgency = dayArray[selectedDay]
        return task
    }
    
    /// NavigationBar初期化
    private func initNavigationBar() {
        if taskViewModel.isViewer {
            self.title = TITLE_EDIT
            let image = UIImage(systemName: "checkmark.circle")
            let completeButton = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(completeTask))
            let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteTask))
            deleteButton.tintColor = UIColor.red
            navigationItem.rightBarButtonItems = [deleteButton, completeButton]
        } else {
            self.title = TITLE_ADD_TASK
            let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(tapSaveButton(_:)))
            let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(tapCloseButton(_:)))
            navigationItem.rightBarButtonItems = [saveButton]
            navigationItem.leftBarButtonItems = [closeButton]
        }
    }
    
    // MARK: - Action
    
    /// 閉じるボタン
    @objc func tapCloseButton(_ sender: UIBarButtonItem) {
        // 入力済みの場合は確認アラート表示
        if !titleTextField.text!.isEmpty || !memoTextView.text.isEmpty {
            let alert = Alert.OKCancel(title: "", message: MESSAGE_DELETE_INPUT, OKAction: {
                self.delegate?.taskVCDismiss(self)
            })
            present(alert, animated: true)
            return
        }
        delegate?.taskVCDismiss(self)
    }
    
    /// タスクを削除
    @objc func deleteTask() {
        let alert = Alert.Delete(title: TITLE_DELETE_TASK, message: MESSAGE_DELETE_TASK, OKAction: { [self] in
            self.taskViewModel.deleteTask()
            self.delegate?.taskVCDeleteTask(task: self.taskViewModel.task!)
        })
        present(alert, animated: true)
    }
    
    /// Taskを完了にする
    @objc func completeTask() {
        let message = taskViewModel.task!.isComplete ? MESSAGE_INCOMPLETE_TASK : MESSAGE_COMPLETE_TASK
        let alert = Alert.OKCancel(title: TITLE_COMPLETE_TASK, message: message, OKAction: {
            self.taskViewModel.completeTask()
            self.delegate?.taskVCDeleteTask(task: self.taskViewModel.task!)
        })
        present(alert, animated: true)
    }
    
    /// 保存ボタン
    @objc func tapSaveButton(_ sender: UIBarButtonItem) {
        // 入力チェック
        if titleTextField.text!.isEmpty {
            let alert = Alert.Error(message: ERROR_MESSAGE_EMPTY_TITLE)
            present(alert, animated: true)
            return
        }
        
        // Taskを作成
        let task = applyTask()
        let result = taskViewModel.saveTask(task: task)
        if !result {
            let alert = Alert.Error(message: ERROR_MESSAGE_SAVE_FAILED)
            present(alert, animated: true)
            return
        }
        
        // モーダルを閉じる
        delegate?.taskVCAddTask(self, task: task)
    }
    
    /// カラーボタン
    @IBAction func tapColorButton(_ sender: Any) {
        hideKeyboard()
        closePicker(pickerView)
        let toolbar = createToolBar(#selector(colorPickerDoneAction), #selector(colorPickerCancelAction))
        pickerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: colorPicker.bounds.size.height + 88 + view.safeAreaInsets.bottom))
        pickerView.backgroundColor = UIColor.systemGray5
        pickerView.addSubview(colorPicker)
        pickerView.addSubview(toolbar)
        openPicker(pickerView)
    }
    
    /// 重要度スライダー
    @IBAction func slideImportanceSlider(_ sender: UISlider) {
        let value = Int(round(sender.value))
        importanceValueLabel.text = String(value)
        typeValueLabel.text = taskViewModel.getTaskType(importance: importanceValueLabel.text!, urgency: urgencyValueLabel.text!)
    }
    
    /// 緊急度スライダー
    @IBAction func slideUrgencySlider(_ sender: UISlider) {
        let value = Int(round(sender.value))
        urgencyValueLabel.text = String(value)
        typeValueLabel.text = taskViewModel.getTaskType(importance: importanceValueLabel.text!, urgency: urgencyValueLabel.text!)
    }
    
    /// 期限日スイッチ
    @IBAction func tapDeadlineSwitch(_ sender: UISwitch) {
        setDeadlineSwitch(isOn: sender.isOn)
    }
    
    /// 期限日スイッチの切替
    /// - Parameter isOn: ON or OFF
    private func setDeadlineSwitch(isOn :Bool) {
        deadlineSwitch.isOn = isOn
        deadlineDateButton.isHidden  = deadlineSwitch.isOn ? false : true
        updateUrgencyLabel.isHidden  = deadlineSwitch.isOn ? false : true
        updateUrgencyButton.isHidden = deadlineSwitch.isOn ? false : true
    }
    
    /// 期限日ボタン
    @IBAction func tapDeadlineDateButton(_ sender: Any) {
        hideKeyboard()
        closePicker(pickerView)
        let toolbar = createToolBar(#selector(datePickerDoneAction), #selector(datePickerCancelAction))
        pickerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: datePicker.bounds.size.height + 88 + view.safeAreaInsets.bottom))
        pickerView.backgroundColor = UIColor.systemGray5
        pickerView.addSubview(datePicker)
        pickerView.addSubview(toolbar)
        openPicker(pickerView)
    }
    
    /// 緊急度自動引き上げ日ボタン
    @IBAction func tapUpdateUrgencyButton(_ sender: Any) {
        hideKeyboard()
        closePicker(pickerView)
        let toolbar = createToolBar(#selector(dayPickerDoneAction), #selector(dayPickerCancelAction))
        pickerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: dayPicker.bounds.size.height + 88 + view.safeAreaInsets.bottom))
        pickerView.backgroundColor = UIColor.systemGray5
        pickerView.addSubview(dayPicker)
        pickerView.addSubview(toolbar)
        openPicker(pickerView)
    }
    
}

extension TaskViewController: UIPickerViewDelegate,UIPickerViewDataSource {
    
    /// DatePicker初期化
    private func initDatePicker() {
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ja")
        datePicker.backgroundColor = UIColor.systemGray5
        datePicker.frame = CGRect(x: 0, y: 44, width: UIScreen.main.bounds.size.width, height: datePicker.bounds.size.height)
        datePicker.date = selectedDate
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .inline
        }
    }
    
    /// DatePicker完了処理
    @objc func datePickerDoneAction() {
        selectedDate = datePicker.date
        deadlineDateButton.setTitle(Converter.dateToString(date: selectedDate), for: .normal)
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
        colorPicker.frame = CGRect(x: 0, y: 44, width: self.view.bounds.size.width, height: colorPicker.bounds.size.height)
        colorPicker.backgroundColor = UIColor.systemGray5
        colorPicker.tag = PickerType.color.rawValue
    }
    
    /// ColorPicker完了処理
    @objc func colorPickerDoneAction() {
        selectedColor = colorPicker.selectedRow(inComponent: 0)
        closePicker(pickerView)
        colorButton.backgroundColor = TaskColor.allCases[selectedColor].color
        colorButton.setTitle(TaskColor.allCases[selectedColor].title, for: .normal)
    }
    
    /// ColorPickerキャンセル処理
    @objc func colorPickerCancelAction() {
        colorPicker.selectRow(selectedColor, inComponent: 0, animated: false)
        closePicker(pickerView)
    }
    
    /// DayPicker初期化
    private func initDayPicker() {
        dayPicker.delegate = self
        dayPicker.dataSource = self
        dayPicker.frame = CGRect(x: 0, y: 44, width: self.view.bounds.size.width, height: dayPicker.bounds.size.height)
        dayPicker.backgroundColor = UIColor.systemGray5
        dayPicker.tag = PickerType.day.rawValue
        dayPicker.selectRow(selectedDay, inComponent: 0, animated: false)
    }
    
    /// DayPicker完了処理
    @objc func dayPickerDoneAction() {
        selectedDay = dayPicker.selectedRow(inComponent: 0)
        closePicker(pickerView)
        updateUrgencyButton.setTitle(Converter.updateUrgencyString(day: dayArray[selectedDay]), for: .normal)
    }
    
    /// DayPickerキャンセル処理
    @objc func dayPickerCancelAction() {
        dayPicker.selectRow(selectedDay, inComponent: 0, animated: false)
        closePicker(pickerView)
    }
    
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
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            imageView.image = UIImage(systemName: "circle.fill")
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = TaskColor.allCases[row].color
            customView.addSubview(imageView)
            let label = UILabel(frame: CGRect(x: 30, y: 0, width: 100, height: 30))
            label.font = UIFont(name: "HiraKakuProN-W3", size: 18)
            label.text = TaskColor.allCases[row].title
            label.textAlignment = .center
            customView.addSubview(label)
            return customView
        case .day:
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
            label.font = UIFont(name: "HiraKakuProN-W3", size: 18)
            label.text = Converter.updateUrgencyString(day: dayArray[row])
            label.textAlignment = .center
            let stackView = UIStackView(arrangedSubviews: [label])
            stackView.axis = .horizontal
            stackView.alignment = .center
            return stackView
        }
    }
    
}

extension TaskViewController: UITextFieldDelegate {

    /// フォーカスが外れる前
    /// - Parameter textField: 対象のテキストフィールド
    /// - Returns: trueでフォーカスを外す falseでフォーカスを外さない
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if taskViewModel.isViewer && textField.text == "" {
            textField.text = taskViewModel.task!.title
            let alert = Alert.Error(message: ERROR_MESSAGE_EMPTY_TITLE)
            present(alert, animated: true)
            return false
        }
        return true
    }
    
    /// キーボードを閉じる
    private func hideKeyboard() {
        titleTextField.resignFirstResponder()
        memoTextView.resignFirstResponder()
    }
    
}
