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
    
    /// 緊急度自動引き上げ日のStringを取得(ラベル表示用)
    /// - Parameter day: 引き上げ日
    /// - Returns: 緊急度自動引き上げ日の文字列
    static func updateUrgencyString(day: Int) -> String {
        return "\(TITLE_DEADLINE_DATE)\(day)日前"
    }
    
    /// 指定日数前のDateを取得
    /// - Parameters:
    ///   - date: 基準の日付
    ///   - daysAgo: 日数
    /// - Returns: 指定日数前のDate
    static func getDaysAfterDate(date: Date, daysAfter: Int) -> Date {
        let ago = TimeInterval(daysAfter * 24 * 60 * 60)
        return date.addingTimeInterval(ago)
    }
    
    /// 緊急度自動引き上げ日のDateを取得
    /// - Parameter day: 引き上げ日
    /// - Returns: 緊急度自動引き上げ日の文字列
    static func updateUrgencyDate(task: Task) -> Date {
        let daysAgo = TimeInterval(task.daysBeforeUpdateUrgency * 24 * 60 * 60)
        return task.deadlineDate!.addingTimeInterval(-daysAgo)
    }
    
}
