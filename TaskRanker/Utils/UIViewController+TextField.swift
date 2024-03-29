//
//  UIViewController+TextField.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2022/09/11.
//

import UIKit

public extension UIViewController {
    
    /// TextField初期化
    /// - Parameters:
    ///    - textField: 初期化したいtextField
    ///    - placeholder: 入力するplaceholder文字列
    func initTextField(textField: UITextField, placeholder: String) {
        initTextField(textField: textField, placeholder: placeholder, text: "", doneAction: #selector(hideKeyboard(_:)))
    }
    
    /// TextField初期化
    /// - Parameters:
    ///    - textField: 初期化したいtextField
    ///    - placeholder: 入力するplaceholder文字列
    ///    - text: 入力する文字列
    func initTextField(textField: UITextField, placeholder: String, text: String) {
        initTextField(textField: textField, placeholder: placeholder, text: text, doneAction: #selector(hideKeyboard(_:)))
    }
    
    /// TextField初期化
    /// - Parameters:
    ///    - textField: 初期化したいtextField
    ///    - placeholder: 入力するplaceholder文字列
    ///    - text: 入力する文字列
    ///    - doneAction: 完了ボタンのアクション
    private func initTextField(textField: UITextField, placeholder: String, text: String, doneAction: Selector) {
        textField.text = text
        textField.placeholder = placeholder
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5.0
        textField.layer.masksToBounds = true
        if !Device.isiPad() {
            textField.inputAccessoryView = createToolBar(doneAction, nil)
        }
    }
    
    // テキストフィールド以外をタップでキーボードを下げる設定
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

