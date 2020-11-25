//
//  AppFlow.swift
//  WakeUp!
//
//  Created by 강민석 on 2020/11/24.
//

import UIKit
import RxFlow
import RxCocoa
import RxSwift

class AppFlow: Flow {

    // MARK: - Properties
    private let window: UIWindow
    private let service: MainService

    lazy var root: Presentable = UIViewController()

    // MARK: - Init
    init(window: UIWindow, service: MainService) {
        self.window = window
        self.service = service
    }

    deinit {
        print("\(type(of: self)): \(#function)")
    }

    // MARK: - Navigation Switch
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }

        switch step {
        case .introIsRequired:
            return navigateToIntro()
        case .tabBarIsRequired:
            return navigationToTabBar()
        }
    }
}

// MARK: - Navigate to TabBar
extension AppFlow {
    private func navigationToTabBar() -> FlowContributors {
        let tabBarFlow = TabBarFlow(withService: self.service)

        Flows.use(tabBarFlow, when: .created) { [unowned self] root in
            self.window.rootViewController = root

            UIView.transition(with: self.window,
                              duration: 0.5,
                              options: [.transitionCrossDissolve],
                              animations: nil,
                              completion: nil)
        }

        return .one(flowContributor: .contribute(withNextPresentable: tabBarFlow,
                                                 withNextStepper: OneStepper(withSingleStep: TabBarStep.tabBarIsRequired)))
    }
}

// MARK: - Navigate to Intro
extension AppFlow {
    private func navigateToIntro() -> FlowContributors {
        let introFlow = IntroFlow(withService: self.service)

        Flows.use(introFlow, when: .created) { [unowned self] root in
            self.window.rootViewController = root

            UIView.transition(with: self.window,
                              duration: 0.5,
                              options: [.transitionCrossDissolve],
                              animations: nil,
                              completion: nil)
        }

        return .one(flowContributor: .contribute(withNextPresentable: introFlow,
                                                 withNextStepper: OneStepper(withSingleStep: IntroStep.introIsRequired)))
    }
}
