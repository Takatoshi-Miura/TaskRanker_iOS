//
//  CharacterViewController.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2023/03/22.
//

import UIKit

class CharacterViewController: UIViewController {
    
    // MARK: - UI,Variable
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var settingButton: UIButton!
    private var characterViewModel: CharacterViewModel
    
    // MARK: - Initializer
    
    init(character: Character) {
        characterViewModel = CharacterViewModel(character: character)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewWillAppear(_ animate: Bool) {
        super.viewWillAppear(animate)
        Util.animateLabel(label: messageLabel, text: characterViewModel.getMessage())
    }
    
    /// Viewの初期化
    func initView() {
        titleLabel.text = characterViewModel.getCharacterName()
        descriptionLabel.text = characterViewModel.getDescription()
        imageView.image = characterViewModel.getImage()
        settingButton.setTitle(TITLE_DECISION, for: .normal)
    }
    
    // MARK: - Action
    
    /// 決定ボタン
    @IBAction func tapSettingButton(_ sender: Any) {
        characterViewModel.saveCharacter()
        self.dismiss(animated: true, completion: {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "afterChangeCharacter"), object: nil)
        })
    }

}
