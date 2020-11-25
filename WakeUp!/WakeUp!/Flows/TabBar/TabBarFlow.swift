//
//  TabBarFlow.swift
//  WakeUp!
//
//  Created by 강민석 on 2020/11/24.
//

import UIKit
import RxFlow

class TabBarFlow: Flow {

    private let service: MainService
    
    var root: Presentable {
        return rootViewController
    }

    private var rootViewController = UITabBarController()
    
    init(withService service: MainService) {
        self.service = service
    }

    deinit {
        print("\(type(of: self)): \(#function)")
    }

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? TabBarStep else { return .none }

        switch step {
        case .tabBarIsRequired:
            return navigateToTabBar()
        }
    }
}

// MARK: - Navigate to TabBar
extension TabBarFlow {
    private func navigateToTabBar() -> FlowContributors {
        let mainFlow = MainFlow(withService: self.service)
        let profileFlow = ProfileFlow(withService: self.service)

        Flows.use(mainFlow, profileFlow, when: .created) { [unowned self] (root1, root2: UINavigationController) in

            let tabBarItem1 = UITabBarItem(title: nil, image: R.image.homeIcon(), selectedImage: nil)
            let tabBarItem2 = UITabBarItem(title: nil, image: R.image.profileIcon(), selectedImage: nil)
            
            root1.tabBarItem = tabBarItem1
            root1.title = "Home"
            root2.tabBarItem = tabBarItem2
            root2.title = "Profile"
            
            self.rootViewController.setViewControllers([root1, root2], animated: true)
        }

        return .multiple(flowContributors: [
            .contribute(withNextPresentable: mainFlow,
                        withNextStepper: OneStepper(withSingleStep: MainStep.mainIsRequired)),
            .contribute(withNextPresentable: profileFlow,
                        withNextStepper: OneStepper(withSingleStep: ProfileStep.profileIsRequired))
        ])
    }
}
