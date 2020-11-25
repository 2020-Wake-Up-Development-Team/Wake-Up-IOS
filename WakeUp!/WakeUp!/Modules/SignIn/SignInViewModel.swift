//
//  SignInViewModel.swift
//  WakeUp!
//
//  Created by 강민석 on 2020/11/24.
//

import RxSwift
import RxCocoa

class SignInViewModel: BaseViewModel {
    
    let id = BehaviorRelay(value: "")
    let password = BehaviorRelay(value: "")
    
    // MARK: - Struct
    struct Input {
        let signInSelection: Observable<Void>
    }

    struct Output {
        let signInButtonEnabled: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        input.signInSelection.flatMapLatest { [weak self] () -> Observable<User> in
            guard let self = self else  { return Observable.just(User()) }
            
            let id = self.id.value
            let password = self.password.value
            return self.service.signIn(id: id, password: password)
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
        
        let signInButtonEnabled = BehaviorRelay.combineLatest(id, password, self.loading.asObservable()) {
            return !$0.isEmpty && !$1.isEmpty && !$2
        }.asDriver(onErrorJustReturn: false)
        
        return Output(signInButtonEnabled: signInButtonEnabled)
    }
}
