//
//  Character.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2023/03/21.
//

import UIKit

enum Character: Int, CaseIterable {
    
    case main       // メインキャラ
    case sub        // サブキャラ
    case chipoyo    // ちいぽよ
    case tapoyo     // たあぽよ
    case togepoyo   // とげぽよ
    case warupoyo   // わるぽよ
    case tencho     // てんちょう
    
    /// 有効化
    var isEnable: Bool {
        switch self {
        case .main:     return true
        case .sub:      return true
        case .chipoyo:  return false
        case .tapoyo:   return false
        case .togepoyo: return false
        case .warupoyo: return false
        case .tencho:   return false
        }
    }
    
    /// コマンド（メモに入力してTask作成でキャラクター解放）
    var command: String {
        switch self {
        case .main:     return ""
        case .sub:      return ""
        case .chipoyo:  return "まむずいか　かるたとみぐじ\nぞなのへみ　まよれ"
        case .tapoyo:   return "ぶぶちまこ　すぼとるてすた\nてめこそつ　すろた"
        case .togepoyo: return "おけすちな　のへむゆるがご\nぜづびあお　けすち"
        case .warupoyo: return "くわたやま　くらしのずかな\nかはたはら　くろま"
        case .tencho:   return "くわたきよ　はらしのずかな\nかはたはら　いしい"
        }
    }
    
    /// 設定用画像
    var image: UIImage {
        switch self {
        case .main:     return UIImage(named: "chipoyo_okaeri")!
        case .sub:      return UIImage(named: "tapoyo_okaeri")!
        case .chipoyo:  return UIImage(named: "chipoyo_okaeri")!
        case .tapoyo:   return UIImage(named: "tapoyo_okaeri")!
        case .togepoyo: return UIImage(named: "togepoyo_okaeri")!
        case .warupoyo: return UIImage(named: "warupoyo_okaeri")!
        case .tencho:   return UIImage(named: "tencho_okaeri")!
        }
    }
    
    /// キャラクター名
    var name: String {
        switch self {
        case .main:     return "メインキャラクター"
        case .sub:      return "サブキャラクター"
        case .chipoyo:  return "ちいぽよ"
        case .tapoyo:   return "たあぽよ"
        case .togepoyo: return "とげぽよ"
        case .warupoyo: return "わるぽよ"
        case .tencho:   return "てんちょう"
        }
    }
    
    /// ひとこと
    var message: String {
        switch self {
        case .main:     return "メインキャラクター"
        case .sub:      return "サブキャラクター"
        case .chipoyo:  return "ちいぽよだよ。ちいぽよのほうが かわいいもんね。"
        case .tapoyo:   return "たあぽよだよ。いっしょに がんばろうね！"
        case .togepoyo: return "やーい！うんちいぽよ！うんちいぽよ！"
        case .warupoyo: return "やーい！うんちいぽよ！うんちいぽよ！"
        case .tencho:   return "もうあしたから こなくていいよ。"
        }
    }
    
    /// キャラクター説明
    var description: String {
        switch self {
        case .main:     return "メインキャラクター"
        case .sub:      return "サブキャラクター"
        case .chipoyo:  return "たあぽよのことが大好きなやさしいぽよ。ちょっと面倒くさがり。"
        case .tapoyo:   return "ちいぽよのことが大好きなやさしいぽよ。気ままな性格でちょっぴり泣き虫。"
        case .togepoyo: return "あたまにトゲがついているいじわるなぽよ。いたずら好き。"
        case .warupoyo: return "ふとっちょでいじわるなぽよ。とげぽよとなかよし。"
        case .tencho:   return "ししゃもやさんの店長。仕事ができないぽよはすぐクビにする。"
        }
    }
    
}
