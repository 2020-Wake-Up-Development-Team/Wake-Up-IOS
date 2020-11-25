//
//  MainViewModel.swift
//  WakeUp!
//
//  Created by 강민석 on 2020/11/24.
//

import RxSwift
import RxCocoa

class MainViewModel: BaseViewModel {
    
    struct Input {
        let createClassButtonSelection: Driver<Void>
        let joinClassButtonSelection: Driver<Void>
    }
    
    struct Output {
        let username: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        
        input.createClassButtonSelection.drive(onNext: { [weak self] in
            self?.steps.accept(MainStep.createClassIsRequired)
        }).disposed(by: rx.disposeBag)
        
        input.joinClassButtonSelection.drive(onNext: { [weak self] in
            self?.steps.accept(MainStep.joinClassIsRequired)
        }).disposed(by: rx.disposeBag)
        
//        let username = DatabaseManager.shared.getCurrentUser().username
        let username = "강민석"
        return Output(username: Driver.just(username))
    }
}
