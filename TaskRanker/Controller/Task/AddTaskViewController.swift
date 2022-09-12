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
}

class AddTaskViewController: UIViewController {
    
    // MARK: - UI,Variable
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var detailTextView: UITextView!
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
    var delegate: AddTaskViewControllerDelegate?

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    /// 画面初期化
    private func initView() {
        titleLabel.text = TITLE_TITLE
        detailLabel.text = TITLE_DETAIL
        colorLabel.text = TITLE_COLOR
        importanceLabel.text = TITLE_IMPORTANCE + TITLE_1to8
        urgencyLabel.text = TITLE_URGENCY + TITLE_1to8
        deadlineDateLabel.text = TITLE_DEADLINE_DATE
        repeatLabel.text = TITLE_REPEAT
        
        initTextField(textField: titleTextField, placeholder: "")
        initTextView(textView: detailTextView)
        
        colorButton.setTitle("", for: .normal)
        deadlineDateButton.setTitle("", for: .normal)
        cancelButton.setTitle(TITLE_CANCEL, for: .normal)
        saveButton.setTitle(TITLE_SAVE, for: .normal)
    }
    
    // MARK: - Action
    
    /// 重要度スライダー
    @IBAction func slideImportanceSlider(_ sender: UISlider) {
        importanceValueLabel.text = String(Int(round(sender.value)))
    }
    
    /// 緊急度スライダー
    @IBAction func slideUrgencySlider(_ sender: UISlider) {
        urgencyValueLabel.text = String(Int(round(sender.value)))
    }
    
    
}
