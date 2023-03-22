//
//  CharacterViewController.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2023/03/22.
//

import UIKit

protocol CharacterViewControllerDelegate: AnyObject {
    // キャラクター設定時の処理
    func characterVCSettingDidTap()
}

class CharacterViewController: UIViewController {
    
    // MARK: - UI,Variable
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var settingButton: UIButton!
    var delegate: CharacterViewControllerDelegate?
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Action
    
    /// 決定ボタン
    @IBAction func tapSettingButton(_ sender: Any) {
        delegate?.characterVCSettingDidTap()
    }

}
