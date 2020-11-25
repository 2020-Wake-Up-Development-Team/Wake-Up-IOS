//
//  ProfileFlow.swift
//  WakeUp!
//
//  Created by 강민석 on 2020/11/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxFlow

class ProfileFlow: Flow {
    
    // MARK: - Properties
    var root: Presentable {
        return self.rootViewController
    }

    let rootViewController = UINavigationController()
    private let service: MainService

    // MARK: - Init
    init(withService service: MainService) {
        self.service = service
    }

    deinit {
        print("\(type(of: self)): \(#function)")
    }

    // MARK: - Navigation Switch
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? ProfileStep else { return .none }

        switch step {
        case .profileIsRequired:
            return navigateToProfile()
        }
    }
}

extension ProfileFlow {
    func navigateToProfile() -> FlowContributors {
        let viewModel = ProfileViewModel()
        let viewController = ProfileViewController.instantiate(withViewModel: viewModel,
                                                               andServices: self.service)
        
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController,
                                                 withNextStepper: viewModel))
    }
}
