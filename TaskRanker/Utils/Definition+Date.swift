//
//  Definition+Date.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2023/02/20.
//

import UIKit

/// 日付のStringを取得(ラベル表示用)
/// - Parameter date: 日付
/// - Returns: 日付の文字列
func getDateString(date: Date) -> String {
    return convertDateToString(date: date, format: "yyyy/M/d (E)")
}

/// 期限日のStringを取得(ラベル表示用)
/// - Parameter date: 期限日
/// - Returns: 日付の文字列
func getDeadlineDateString(date: Date) -> String {
    let dateString = convertDateToString(date: date, format: "yyyy/M/d (E)")
    return "期限日：\(dateString)"
}

/// DateをStringに変換
/// - Parameters:
///   - date: 日付
///   - format: フォーマット
/// - Returns: 日付の文字列
private func convertDateToString(date: Date, format: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ja_JP")
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: date)
}
