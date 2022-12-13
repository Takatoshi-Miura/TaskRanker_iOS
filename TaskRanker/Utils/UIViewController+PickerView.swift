//
//  UIViewController+PickerView.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2022/10/13.
//

import UIKit

public extension UIViewController {
    
    /// PickerViewを画面下から表示
    /// - Parameter pickerView: PickerVIewを載せたUIView
    func openPicker(_ pickerView:UIView) {
        view.addSubview(pickerView)
        pickerView.frame.origin.y = UIScreen.main.bounds.size.height
        UIView.animate(withDuration: 0.3) {
            pickerView.frame.origin.y = UIScreen.main.bounds.size.height - pickerView.bounds.size.height
        }
    }
    
    /// PickerViewを閉じる
    /// - Parameter pickerView: PickerVIewを載せたUIView
    func closePicker(_ pickerView:UIView) {
        UIView.animate(withDuration: 0.3) {
            pickerView.frame.origin.y += pickerView.bounds.size.height
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            pickerView.removeFromSuperview()
        }
    }
    
    /// DatePickerから日付を取得
    /// - Parameters:
    ///   - datePicker: UIDatePicker
    ///   - format: 文字列フォーマット yyyy/M/d (E)等
    /// - Returns: フォーマットに変換された日付文字列
    func getDatePickerDate(datePicker: UIDatePicker, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = format
        let returnText = dateFormatter.string(from: datePicker.date)
        return returnText
    }

}

