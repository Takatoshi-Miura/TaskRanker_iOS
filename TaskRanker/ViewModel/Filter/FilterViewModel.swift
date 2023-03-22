//
//  FilterViewModel.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2023/03/16.
//

import UIKit

class FilterViewModel: NSObject {
    
    // MARK: - Variable
    
    var filterArray: [Bool]
    
    // MARK: - Initializer
    
    /// イニシャライザ
    /// - Parameter filterArray: フィルタ配列
    init(filterArray: [Bool]) {
        self.filterArray = filterArray
        super.init()
    }
    
    // MARK: - Action
    
    /// フィルタ配列の初期化
    func clearArray() {
        filterArray = Array(repeating: true, count: TaskColor.allCases.count)
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

extension FilterViewModel: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.imageView?.image = UIImage(systemName: "circle.fill")
        cell.imageView?.tintColor = TaskColor.allCases[indexPath.row].color
        cell.textLabel?.text = TaskColor.allCases[indexPath.row].title
        cell.accessoryType = filterArray[indexPath.row] ? .checkmark : .none
        return cell
    }
    
}
