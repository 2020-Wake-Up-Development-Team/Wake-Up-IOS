//
//  ViewModelBased.swift
//  WakeUp!
//
//  Created by 강민석 on 2020/11/24.
//

import UIKit
import Reusable

// MARK: - For ViewModel
protocol ViewModel {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}

protocol ServicesViewModel: ViewModel {
    associatedtype Service
    var service: Service! { get set }
}

// MARK: - For ViewController
protocol ViewModelBased: class {
    associatedtype ViewModelType: ViewModel
    var viewModel: ViewModelType! { get set }
}

// MARK: - For Instantiate
extension ViewModelBased where Self: StoryboardSceneBased & UIViewController {
    static func instantiate<ViewModelType> (withViewModel viewModel: ViewModelType) -> Self where ViewModelType == Self.ViewModelType {
        let viewController = Self.instantiate()
        viewController.viewModel = viewModel
        return viewController
    }
}

extension ViewModelBased where Self: StoryboardSceneBased & UIViewController, ViewModelType: ServicesViewModel {
    static func instantiate<ViewModelType, ServicesType> (withViewModel viewModel: ViewModelType, andServices service: ServicesType) -> Self
        where ViewModelType == Self.ViewModelType, ServicesType == Self.ViewModelType.Service {
        let viewController = Self.instantiate()
        viewController.viewModel = viewModel
        viewController.viewModel.service = service
        return viewController
    }
}
