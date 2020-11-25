//
//  MainFlow.swift
//  WakeUp!
//
//  Created by 강민석 on 2020/11/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxFlow

class MainFlow: Flow {
    
    // MARK: - Properties
    var root: Presentable {
        return self.rootViewController
    }

//    let rootViewController = UINavigationController()
    private let service: MainService
    
    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        // Navigation Bar를 transparent하게
        viewController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        viewController.navigationBar.shadowImage = UIImage()
        viewController.navigationBar.isTranslucent = true
        return viewController
    }()

    // MARK: - Init
    init(withService service: MainService) {
        self.service = service
    }

    deinit {
        print("\(type(of: self)): \(#function)")
    }

    // MARK: - Navigation Switch
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? MainStep else { return .none }

        switch step {
        case .mainIsRequired:
            return navigateToMain()
        case .createClassIsRequired:
            return navigateToCreateClass()
        case .joinClassIsRequired:
            return navigateToJoinClass()
        case .videoCastIsRequired(let channelID):
            return navigateToVideoCast(channelID: channelID)
        case .popViewController:
            self.rootViewController.popViewController(animated: true)
            return .none
        }
    }
}


extension MainFlow {
    private func navigateToMain() -> FlowContributors {
        let viewModel = MainViewModel()
        let viewController = MainViewController.instantiate(withViewModel: viewModel,
                                                            andServices: self.service)
        
        rootViewController.pushViewController(viewController, animated: false)
        return .one(flowContributor: .contribute(withNextPresentable: viewController,
                                                 withNextStepper: viewModel))
    }
    
    private func navigateToCreateClass() -> FlowContributors {
        let randChannelID: String! = String(arc4random_uniform(9999))
        
        let viewModel = VideoCastViewModel(channelID: randChannelID)
        let viewController = VideoCastViewController.instantiate(withViewModel: viewModel,
                                                                 andServices: self.service)
        
        rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController,
                                                 withNextStepper: viewModel))
    }
    
    private func navigateToJoinClass() -> FlowContributors {
        let viewController = JoinClassViewController.instantiate()
        
        rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNext: viewController))
    }
    
    private func navigateToVideoCast(channelID: String) -> FlowContributors {
        let viewModel = VideoCastViewModel(channelID: channelID)
        let viewController = VideoCastViewController.instantiate(withViewModel: viewModel,
                                                                 andServices: self.service)
        
        rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController,
                                                 withNextStepper: viewModel))
    }
}
