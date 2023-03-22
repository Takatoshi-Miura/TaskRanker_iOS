//
//  HomeViewModel.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2023/03/15.
//

import UIKit

class HomeViewModel {
    
    // MARK: - Variable
    
    private var filterArray: [Bool]
    private var selectedTask: Task?
    private var selectedIndex: IndexPath?
    
    
    // MARK: - Initializer
    
    init() {
        filterArray = Array(repeating: true, count: TaskColor.allCases.count)
        clearTaskIndex()
    }
    
    // MARK: - Navigation
    
    /// NavigationBarのタイトルを取得
    /// - Parameter type: TaskType
    /// - Returns: ラベル
    func getNavigationLabel(type: TaskType) -> UILabel {
        let titleLabel = UILabel()
        titleLabel.text = type.naviTitle
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.textColor = .label
        let attrText = NSMutableAttributedString(string: titleLabel.text!)
        attrText.addAttribute(.foregroundColor, value: type.importanceColor, range: NSMakeRange(4, 1))
        attrText.addAttribute(.foregroundColor, value: type.urgencyColor, range: NSMakeRange(11, 1))
        titleLabel.attributedText = attrText
        return titleLabel
    }
    
    // MARK: - Filter
    
    /// フィルタ適用有無を返却
    /// - Returns: フィルタ適用有無
    func isFilter() -> Bool {
        return (filterArray.firstIndex(of: false) != nil) ? true : false
    }
    
    /// フィルタをセット
    /// - Parameter array: フィルタ配列
    func setFilterArray(array: [Bool]) {
        filterArray = array
    }
    
    /// フィルタを取得
    /// - Returns: フィルタ配列
    func getFilterArray() -> [Bool] {
        return filterArray
    }
    
    // MARK: - Index
    
    /// 選択したTask情報を保存
    /// - Parameters:
    ///   - task: Task
    ///   - indexPath: IndexPath
    func setTaskIndex(task: Task, indexPath: IndexPath) {
        selectedTask = task
        selectedIndex = indexPath
    }
    
    /// 選択したTask情報をクリア
    func clearTaskIndex() {
        selectedTask = nil
        selectedIndex = nil
    }
    
    /// 選択したTaskを取得
    /// - Returns: Task
    func getSelectedTask() -> Task? {
        return selectedTask
    }
    
    /// 選択したIndexPathを取得
    /// - Returns: IndexPath
    func getSelectedIndex() -> IndexPath? {
        return selectedIndex
    }
    
}
