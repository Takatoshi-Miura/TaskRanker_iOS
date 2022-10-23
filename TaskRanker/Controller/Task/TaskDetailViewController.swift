//
//  TaskDetailViewController.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2022/10/23.
//

import UIKit

protocol TaskDetailViewControllerDelegate: AnyObject {
    /// 画面を閉じる
    func taskDetailVCDismiss(_ viewController: UIViewController, task: Task)
}

class TaskDetailViewController: UIViewController {
    
    // MARK: - UI,Variable
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var memoLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var importanceLabel: UILabel!
    @IBOutlet weak var importanceValueLabel: UILabel!
    @IBOutlet weak var urgencyLabel: UILabel!
    @IBOutlet weak var urgencyValueLabel: UILabel!
    @IBOutlet weak var deadlineDateLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var colorButton: UIButton!
    @IBOutlet weak var deadlineDateButton: UIButton!
    @IBOutlet weak var repeatLabel: UILabel!
    private var pickerView = UIView()
    private let colorPicker = UIPickerView()
    private var datePicker = UIDatePicker()
    private var colorIndex: Int = 0
    private var selectedDate = Date()
    var task = Task()
    var delegate: TaskDetailViewControllerDelegate?
    
    // MARK: - LifeCycle
    
    init(task: Task) {
        self.task = task
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initDatePicker()
        initColorPicker()
        inputTask()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // マルチタスクビュー対策
        datePicker.frame.size.width = self.view.bounds.size.width
        colorPicker.frame.size.width = self.view.bounds.size.width
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.taskDetailVCDismiss(self, task: task)
    }
    
    /// 画面初期化
    private func initView() {
        self.title = TITLE_EDIT
        titleLabel.text = TITLE_TITLE
        memoLabel.text = TITLE_DETAIL
        colorLabel.text = TITLE_COLOR
        importanceLabel.text = TITLE_IMPORTANCE + TITLE_1to8
        urgencyLabel.text = TITLE_URGENCY + TITLE_1to8
        deadlineDateLabel.text = TITLE_DEADLINE_DATE
        repeatLabel.text = TITLE_REPEAT
        
        initTextField(textField: titleTextField, placeholder: "")
        initTextView(textView: memoTextView)
        titleTextField.delegate = self
        memoTextView.delegate = self
        
        colorButton.backgroundColor = Color.allCases[colorIndex].color
        colorButton.setTitle(Color.allCases[colorIndex].title, for: .normal)
        deadlineDateButton.setTitle(getDatePickerDate(datePicker: datePicker, format: "yyyy/M/d (E)"), for: .normal)
    }
    
    /// Taskの中身を反映
    private func inputTask() {
        titleTextField.text = task.title
        memoTextView.text = task.memo
        colorButton.backgroundColor = Color.allCases[task.color].color
        colorButton.setTitle(Color.allCases[task.color].title, for: .normal)
        // TODO: 緊急度反映
        selectedDate = task.deadlineDate ?? Date()
        datePicker.setDate(selectedDate, animated: false)
        deadlineDateButton.setTitle(getDatePickerDate(datePicker: datePicker, format: "yyyy/M/d (E)"), for: .normal)
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
    
}

extension TaskDetailViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
        colorButton.backgroundColor = Color.allCases[colorIndex].color
        colorButton.setTitle(Color.allCases[colorIndex].title, for: .normal)
        task.color = colorIndex
    }
    
    /// ColorPickerキャンセル処理
    @objc func colorPickerCancelAction() {
        colorPicker.selectRow(colorIndex, inComponent: 0, animated: false)
        closePicker(pickerView)
    }
    
}

extension TaskDetailViewController: UITextFieldDelegate {

    /// フォーカスが外れる前
    /// - Parameter textField: 対象のテキストフィールド
    /// - Returns: trueでフォーカスを外す falseでフォーカスを外さない
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text == "" {
            showErrorAlert(message: ERROR_MESSAGE_EMPTY_TITLE)
            textField.text = task.title
            return false
        }
        task.title = textField.text!
        return true
    }
    
}

extension TaskDetailViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        task.memo = textView.text
    }
    
}
