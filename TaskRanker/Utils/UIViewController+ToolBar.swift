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
    ///    - cancelAction: キャンセルボタンの処理(nilの場合は完了ボタンのみ表示)
    /// - Returns: ツールバー
    func createToolBar(_ doneAction: Selector, _ cancelAction: Selector?) -> UIToolbar {
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: doneAction)
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: cancelAction)
        let flexibleItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let items = (cancelAction != nil) ? [cancelItem,flexibleItem,doneItem] : [flexibleItem, doneItem]
        let toolbar = UIToolbar()
        toolbar.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 44)
        toolbar.setItems(items, animated: true)
        return toolbar
    }
    
}
