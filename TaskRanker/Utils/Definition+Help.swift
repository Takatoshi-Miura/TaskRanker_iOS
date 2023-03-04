//
//  Definition+Help.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2023/03/04.
//

import UIKit

/// ヘルプ
enum HelpItem: Int, CaseIterable {
    case outline
    case addTask
    case taskType
    case taskList
    case taskMap
    case filter
    case complete
    
    var title: String {
        switch self {
        case .outline:  return "TaskRankerとは"
        case .addTask:  return "タスクの作成"
        case .taskType: return "タスクの分類"
        case .taskList: return "タスク管理-リスト"
        case .taskMap:  return "タスク管理-マップ"
        case .filter:   return "フィルタ"
        case .complete: return "タスクの完了"
        }
    }
    
    var detail: String {
        switch self {
        case .outline:  return "タスクの優先順位付けを行ってくれるタスク管理アプリです。\nタスクの重要度と緊急度から優先順位を判定し、タスクを分類します。"
        case .addTask:  return "＋ボタンからタスクを作成できます。\n重要度と緊急度を8段階で設定できます。\n期限日を設定すると期限日の　日前に自動的に緊急度を引き上げます。"
        case .taskType: return "重要度と緊急度によって、4つのタイプに分類します。\nA：重要度5〜8, 緊急度5~8, B：重要度5〜8, 緊急度1~4\nC：重要度1〜4, 緊急度5~8, D：重要度1〜4, 緊急度1~4"
        case .taskList: return "作成したタスクは一覧で管理できます。\nタスクは重要度が高い順に表示されます。"
        case .taskMap:  return "作成したタスクはマップ表示でも管理できます。\n右上のものほど重要度、緊急度が高いタスクです。"
        case .filter:   return "表示するタスクは、フィルタからカラーで絞り込むことができます。"
        case .complete: return "タスクの◯をタップすると完了にできます。\n完了したタスクは完了済みタスク画面で確認できます。"
        }
    }
    
    var image: UIImage {
        switch self {
        case .outline:  return UIImage(systemName: "gear")!
        case .addTask:  return UIImage(systemName: "gear")!
        case .taskType: return UIImage(systemName: "gear")!
        case .taskList: return UIImage(systemName: "gear")!
        case .taskMap:  return UIImage(systemName: "gear")!
        case .filter:   return UIImage(systemName: "gear")!
        case .complete: return UIImage(systemName: "gear")!
        }
    }
}
