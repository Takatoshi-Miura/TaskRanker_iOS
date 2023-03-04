//
//  TutorialViewController.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2022/10/11.
//

import UIKit

class TutorialViewController: UIViewController {
    
    // MARK: - UI,Variable
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var helpItem: HelpItem
    
    // MARK: - Initializer
    
    /// イニシャライザ
    /// - Parameter helpItem: ヘルプアイテム
    init(helpItem: HelpItem) {
        self.helpItem = helpItem
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text  = helpItem.title
        detailLabel.text = helpItem.detail
        imageView.image  = helpItem.image
    }
    
}
