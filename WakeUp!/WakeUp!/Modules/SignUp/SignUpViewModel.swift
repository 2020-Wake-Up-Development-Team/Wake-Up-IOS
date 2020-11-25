//
//  SignUpViewModel.swift
//  WakeUp!
//
//  Created by 강민석 on 2020/11/24.
//

import RxSwift
import RxCocoa

class SignUpViewModel: BaseViewModel {
    
    let id = BehaviorRelay(value: "")
    let password = BehaviorRelay(value: "")
    let school = BehaviorRelay(value: "")
    let schoolClass = BehaviorRelay(value: "")
    let username = BehaviorRelay(value: "")
    
    // MARK: - Struct
    struct Input {
        let signUpButtonSelection: Observable<Void>
    }
    
    struct Output {
        let signUpButtonEnabled: Driver<Bool>
    }
}

extension SignUpViewModel {
    func transform(input: Input) -> Output {
        
        // MARK: - Input
        input.signUpButtonSelection.flatMapLatest { [weak self] () -> Observable<User> in
            guard let self = self else  { return Observable.just(User()) }
            let id = self.id.value
            let password = self.password.value
            let school = self.school.value
            let schoolClass = self.schoolClass.value
            let username = self.username.value
            
            
            return self.service.signUp(id: id,
                                       password: password,
                                       school: school,
                                       schoolClass: schoolClass,
                                       username: username)
                .trackActivity(self.loading)
        }.subscribe(onNext: { (user) in
            DatabaseManager.shared.saveUser(user)
            loggedIn.accept(true)
            UserDefaults.standard.set(true, forKey: "loginState")
            KeychainManager.shared.username = user.username
        }, onError: { (error) in
            loggedIn.accept(false)
            self.error.onNext(error as! ErrorResponse)
        }).disposed(by: rx.disposeBag)
        
        let signUpButtonEnabled = BehaviorRelay.combineLatest(id, password, school, schoolClass, username, self.loading.asObservable()) {
            return !$0.isEmpty && !$1.isEmpty && !$2.isEmpty && !$3.isEmpty && !$4.isEmpty && !$5
        }.asDriver(onErrorJustReturn: false)
        
        return Output(signUpButtonEnabled: signUpButtonEnabled)
    }
}
