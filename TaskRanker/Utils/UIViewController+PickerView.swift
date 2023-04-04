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
    func openPicker(_ pickerView: UIView) {
        tabBarController?.tabBar.isHidden = true
        view.addSubview(pickerView)
        pickerView.frame.origin.y = UIScreen.main.bounds.size.height
        UIView.animate(withDuration: 0.3) {
            pickerView.frame.origin.y = UIScreen.main.bounds.size.height - pickerView.bounds.size.height
        }
    }
    
    /// PickerViewを閉じる
    /// - Parameter pickerView: PickerVIewを載せたUIView
    func closePicker(_ pickerView: UIView) {
        tabBarController?.tabBar.isHidden = false
        UIView.animate(withDuration: 0.3) {
            pickerView.frame.origin.y += pickerView.bounds.size.height
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            pickerView.removeFromSuperview()
        }
    }

}

