//
//  SignInViewController.swift
//  WakeUp!
//
//  Created by 강민석 on 2020/11/24.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa

class SignInViewController: BaseViewController, StoryboardSceneBased {
    
    static let sceneStoryboard = R.storyboard.signIn()

    @IBOutlet weak var iDField: UITextField!
    @IBOutlet weak var pWField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        guard let viewModel = self.viewModel as? SignInViewModel else { fatalError("ViewModel: \(self.viewModel!) Casting Error") }
        
        iDField.rx.text.orEmpty
            .bind(to: viewModel.id)
            .disposed(by: rx.disposeBag)
        
        pWField.rx.text.orEmpty
            .bind(to: viewModel.password)
            .disposed(by: rx.disposeBag)
        
        let input = SignInViewModel.Input(signInSelection: signInButton.rx.tap.asObservable())
        let output = viewModel.transform(input: input)
        
        output.signInButtonEnabled
            .drive(self.signInButton.rx.isEnabled)
            .disposed(by: rx.disposeBag)
    }
}
