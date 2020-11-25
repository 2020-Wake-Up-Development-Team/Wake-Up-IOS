//
//  JoinClassViewController.swift
//  WakeUp!
//
//  Created by 강민석 on 2020/11/24.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa
import RxFlow

class JoinClassViewController: UIViewController, StoryboardSceneBased, Stepper {
    
    static let sceneStoryboard = R.storyboard.joinClass()
    
    var steps = PublishRelay<Step>()
    
    @IBOutlet weak var channelIDField: UITextField!
    @IBOutlet weak var joinClassButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        stepper()
    }
    
    func stepper() {
        joinClassButton.rx.tap
            .map { [weak self] in
                return MainStep.videoCastIsRequired(channelID: self?.channelIDField.text ?? "")
            }
            .bind(to: steps)
            .disposed(by: rx.disposeBag)
    }
}
