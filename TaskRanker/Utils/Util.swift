//
//  Util.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2023/03/25.
//

import UIKit

class Util {
    
    /// ラベルに文字列を1文字ずつ表示
    /// - Parameters:
    ///   - label: ラベル
    ///   - text: 文字列
    static func animateLabel(label: UILabel, text: String) {
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttribute(.foregroundColor, value: UIColor.clear, range: NSRange(location: 0, length: text.count))
        label.attributedText = attributedText
        
        let charCount = text.count
        for i in 0..<charCount {
            let range = NSRange(location: i, length: 1)
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.1) {
                attributedText.addAttribute(.foregroundColor, value: UIColor.label, range: range)
                label.attributedText = attributedText
            }
        }
    }
    
}
