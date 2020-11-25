//
//  AppStepper.swift
//  WakeUp!
//
//  Created by 강민석 on 2020/11/24.
//

import RxFlow
import RxSwift
import RxCocoa
import NSObject_Rx

let loggedIn = BehaviorRelay<Bool>(value: false)

// 앱 시작시 로그인 유무를 확인하여 TabBar화면을 표시할지, Intro화면을 표시할지를 정한다.
class AppStepper: NSObject, Stepper {
    
    let steps = PublishRelay<Step>()
    let loginStateKey = "loginState"
    
    // 로그인 여부를 확인하여 Intro화면을 보여줄지 TabBar화면(main)을 줄지를 결정한다.
    var initialStep: Step {
        let isLogin = UserDefaults.standard.bool(forKey: loginStateKey)
        
//        return isLogin ? AppStep.tabBarIsRequired : AppStep.introIsRequired
        return AppStep.tabBarIsRequired
    }
    
    // 로그인 성공시 실행되는 콜백 메서드
    func readyToEmitSteps() {
        loggedIn
            .subscribe(onNext: { [weak self] isLogin in
                if isLogin {
                    self?.steps.accept(AppStep.tabBarIsRequired)
                }
            }).disposed(by: rx.disposeBag)
    }
}
