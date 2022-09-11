//
//  UIViewController+ToolBar.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2022/09/11.
//

import UIKit

public extension UIViewController {
    
    /// ツールバーを作成(キャンセル、完了ボタン)
    /// - Parameters:
    ///    - doneAction: 完了ボタンの処理
    ///    - cancelAction: キャンセルボタンの処理
    /// - Returns: ツールバー
    func createToolBar(_ doneAction:Selector, _ cancelAction:Selector) -> UIToolbar {
        // ツールバーを作成
        let toolbar = UIToolbar()
        toolbar.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 44)
        // ボタン作成＆セット
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: doneAction)
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: cancelAction)
        let flexibleItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.setItems([cancelItem,flexibleItem,doneItem], animated: true)
        // 作成したツールバーを返却
        return toolbar
    }
    
    /// ツールバーを作成(完了ボタン)
    /// - Parameters:
    ///    - doneAction: 完了ボタンの処理
    /// - Returns: ツールバー
    func createToolBar(_ doneAction: Selector) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 44)
        
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: doneAction)
        let flexibleItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexibleItem, doneItem], animated: true)
        
        return toolbar
    }
    
}
