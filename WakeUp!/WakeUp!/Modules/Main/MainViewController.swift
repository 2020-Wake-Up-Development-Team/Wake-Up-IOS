//
//  MainViewController.swift
//  WakeUp!
//
//  Created by 강민석 on 2020/11/24.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa

class MainViewController: BaseViewController, StoryboardSceneBased {
    
    static let sceneStoryboard = R.storyboard.main()
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var createClassButton: UIButton!
    @IBOutlet weak var joinClassButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    override func bindViewModel() {
        super.bindViewModel()
        
        guard let viewModel = viewModel as? MainViewModel else { fatalError("ViewModel: \(self.viewModel!) Casting Error") }
        
        let input = MainViewModel.Input(createClassButtonSelection: createClassButton.rx.tap.asDriver(),
                                        joinClassButtonSelection: joinClassButton.rx.tap.asDriver())
        let output = viewModel.transform(input: input)
        
        output.username.drive(usernameLabel.rx.text).disposed(by: rx.disposeBag)   
    }

}
