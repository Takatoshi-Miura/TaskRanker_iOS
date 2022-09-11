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
    
    
    @IBOutlet weak var importanceLabel: UILabel!
    @IBOutlet weak var urgencyLabel: UILabel!
    
    var delegate: AddTaskViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /// 重要度スライダー
    @IBAction func slideImportanceSlider(_ sender: UISlider) {
        importanceLabel.text = String(Int(round(sender.value)))
    }
    
    /// 緊急度スライダー
    @IBAction func slideUrgencySlider(_ sender: UISlider) {
        urgencyLabel.text = String(Int(round(sender.value)))
    }
    
    
}
