//
//  CharacterViewController.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2023/03/22.
//

import UIKit

protocol CharacterViewControllerDelegate: AnyObject {
    // キャラクター設定時の処理
    func characterVCSettingDidTap(_ viewController: UIViewController)
    // キャンセルタップ時の処理
    func characterVCCancelDidTap(_ viewController: UIViewController)
}

class CharacterViewController: UIViewController {
    
    // MARK: - UI,Variable
    
    var delegate: CharacterViewControllerDelegate?
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
