//
//  IntroViewController.swift
//  WakeUp!
//
//  Created by 강민석 on 2020/11/24.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa
import RxFlow

class IntroViewController: UIViewController, StoryboardSceneBased, Stepper {
    
    static let sceneStoryboard = R.storyboard.intro()
    
    var steps = PublishRelay<Step>()
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        stepper()
    }
}

// MARK: - Stepper
extension IntroViewController {
    func stepper() {
        signInButton.rx.tap
            .map { IntroStep.signInIsRequired }
            .bind(to: steps)
            .disposed(by: rx.disposeBag)

        signUpButton.rx.tap
            .map { IntroStep.signUpIsRequired }
            .bind(to: steps)
            .disposed(by: rx.disposeBag)
    }
}
