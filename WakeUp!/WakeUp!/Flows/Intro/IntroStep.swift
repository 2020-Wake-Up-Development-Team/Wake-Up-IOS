//
//  IntroStep.swift
//  WakeUp!
//
//  Created by 강민석 on 2020/11/24.
//

import RxFlow

enum IntroStep: Step {
    case introIsRequired // initial
    case signInIsRequired
    case signUpIsRequired
    case popViewController
}
