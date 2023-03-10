//
//  UIViewController+TextView.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2022/09/11.
//

import UIKit

public extension UIViewController {
    
    /// TextView初期化
    /// - Parameters:
    ///    - textView: 初期化したいtextView
    func initTextView(textView: UITextView) {
        initTextView(textView: textView, doneAction: #selector(hideKeyboard(_:)))
    }
    
    /// TextView初期化
    /// - Parameters:
    ///    - textView: 初期化したいtextView
    ///    - text: 入力する文字列
    func initTextView(textView: UITextView, text: String) {
        initTextView(textView: textView, text: text, doneAction: #selector(hideKeyboard(_:)))
    }
    
    /// TextView初期化
    /// - Parameters:
    ///    - textView: 初期化したいtextView
    ///    - doneAction: 完了ボタンのアクション
    func initTextView(textView: UITextView, doneAction: Selector) {
        initTextView(textView: textView, text: "", doneAction: doneAction)
    }
    
    /// TextView初期化
    /// - Parameters:
    ///    - textView: 初期化したいtextView
    ///    - text: 入力する文字列
    ///    - doneAction: 完了ボタンのアクション
    private func initTextView(textView: UITextView, text: String, doneAction: Selector) {
        textView.text = text
        textView.layer.borderColor = UIColor.systemGray.cgColor
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 5.0
        textView.layer.masksToBounds = true
        if !Device.isiPad() {
            textView.inputAccessoryView = createToolBar(doneAction, nil)
        }
    }
    
    /// キーボードを隠す
    @objc func hideKeyboard(_ sender: UIButton){
        self.view.endEditing(true)
    }
    
}

