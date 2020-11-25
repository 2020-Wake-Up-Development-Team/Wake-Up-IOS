//
//  BaseViewModel.swift
//  WakeUp!
//
//  Created by 강민석 on 2020/11/24.
//

import RxFlow
import RxSwift
import RxCocoa

class BaseViewModel: NSObject, ServicesViewModel, Stepper {

    // MARK: - Properties
    let steps = PublishRelay<Step>()
    var service: MainService!

    let loading = ActivityIndicator()
    let error = PublishSubject<ErrorResponse>()

    var page = 1

    let headerLoading = ActivityIndicator()
    let footerLoading = ActivityIndicator()

    // MARK: - Dummy
    struct Input {
    }

    struct Output {
    }

    func transform(input: Input) -> Output {
        return Output()
    }
}
