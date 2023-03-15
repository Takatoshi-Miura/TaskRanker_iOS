//
//  FilterViewModel.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2023/03/16.
//

import UIKit

class FilterViewModel {
    
    var filterArray = [Bool]()
    
    /// フィルタ配列の設定
    /// - Parameter filterArray: フィルタ配列
    func setupFilterArray(array: [Bool]?) {
        if let array = array {
            filterArray = array
        } else {
            clearArray()
        }
    }
    
    /// フィルタ配列の初期化
    func clearArray() {
        filterArray = Array(repeating: true, count: TaskColor.allCases.count)
    }
    
    /// Cellを返却
    /// - Parameter indexPath: indexPath
    /// - Returns: Cell
    func configureCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = TaskColor.allCases[indexPath.row].title
        cell.accessoryType = filterArray[indexPath.row] ? .checkmark : .none
        return cell
    }
    
    /// フィルタの値を反転
    /// - Parameter indexPath: indexPath
    func toggleValue(indexPath: IndexPath) {
        filterArray[indexPath.row].toggle()
        // 最低1つはチェックが必要
        if filterArray.firstIndex(of: true) == nil {
            filterArray[indexPath.row].toggle()
        }
    }
    
    
}
