
//
//  SignUpViewController.swift
//  WakeUp!
//
//  Created by 강민석 on 2020/11/24.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa

class SignUpViewController: BaseViewController, StoryboardSceneBased {
    
    static let sceneStoryboard = R.storyboard.signUp()

    @IBOutlet weak var iDField: UITextField!
    @IBOutlet weak var pWField: UITextField!
    @IBOutlet weak var schoolField: UITextField!
    @IBOutlet weak var classField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        guard let viewModel = viewModel as? SignUpViewModel else { fatalError("ViewModel: \(self.viewModel!) Casting Error") }
        
        iDField.rx.text.orEmpty
            .bind(to: viewModel.id)
            .disposed(by: rx.disposeBag)
        
        pWField.rx.text.orEmpty
            .bind(to: viewModel.password)
            .disposed(by: rx.disposeBag)
        
        schoolField.rx.text.orEmpty
            .bind(to: viewModel.school)
            .disposed(by: rx.disposeBag)
        
        classField.rx.text.orEmpty
            .bind(to: viewModel.schoolClass)
            .disposed(by: rx.disposeBag)
        
        nameField.rx.text.orEmpty
            .bind(to: viewModel.username)
            .disposed(by: rx.disposeBag)
        
        let input = SignUpViewModel.Input(signUpButtonSelection: signUpButton.rx.tap.asObservable())
        let output = viewModel.transform(input: input)
        
        output.signUpButtonEnabled
            .drive(signUpButton.rx.isEnabled)
            .disposed(by: rx.disposeBag)
    }
}
