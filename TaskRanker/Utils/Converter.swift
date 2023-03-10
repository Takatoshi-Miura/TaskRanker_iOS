//
//  Converter.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2023/03/10.
//

import UIKit

class Converter {
    
    // MARK: - Date
    
    /// 日付のStringを取得(ラベル表示用)
    /// - Parameter date: 日付
    /// - Returns: 日付の文字列
    static func dateToString(date: Date) -> String {
        return self.convertDateToString(date: date, format: "yyyy/M/d (E)")
    }

    /// 期限日のStringを取得(ラベル表示用)
    /// - Parameter date: 期限日
    /// - Returns: 日付の文字列
    static func deadlineDateString(date: Date) -> String {
        let dateString = self.convertDateToString(date: date, format: "yyyy/M/d (E)")
        return "\(TITLE_DEADLINE_DATE)：\(dateString)"
    }
    
    /// DateをStringに変換
    /// - Parameters:
    ///   - date: 日付
    ///   - format: フォーマット
    /// - Returns: 日付の文字列
    static private func convertDateToString(date: Date, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
}
