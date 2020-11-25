//
//  BaseViewController.swift
//  WakeUp!
//
//  Created by 강민석 on 2020/11/24.
//

import UIKit
import RxSwift
import RxCocoa
import NVActivityIndicatorView
import SwiftMessages

class BaseViewController: UIViewController, ViewModelBased, NVActivityIndicatorViewable {

    // MARK: - Properties
    var viewModel: BaseViewModel!
    let isLoading = BehaviorRelay(value: false)
    let error = PublishSubject<ErrorResponse>()

    // MARK: - View life cycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = ""

//        self.navigationController?.navigationBar.backIndicatorImage = R.image.leftArrow()
//        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = R.image.leftArrow()

        bindViewModel()
    }

    // MARK: - BindViewModel
    public func bindViewModel() {
        viewModel.loading.asObservable().bind(to: self.isLoading).disposed(by: rx.disposeBag)
        viewModel.error.bind(to: self.error).disposed(by: rx.disposeBag)

        isLoading.subscribe(onNext: { [weak self] isLoading in
            self?.view.endEditing(true)
            UIApplication.shared.isNetworkActivityIndicatorVisible = isLoading
        }).disposed(by: rx.disposeBag)

        isLoading.asDriver().drive(onNext: { [weak self] isLoading in
            isLoading ? self?.startAnimating(type: .circleStrokeSpin) : self?.stopAnimating()
        }).disposed(by: rx.disposeBag)

        error.subscribe(onNext: { error in
            let errorView = MessageView.viewFromNib(layout: .cardView)
            errorView.configureTheme(.error)
            errorView.configureContent(title: "\(error.status!) 에러", body: error.message)
            errorView.button?.isHidden = true
            SwiftMessages.show(view: errorView)
        }).disposed(by: rx.disposeBag)
    }

    // MARK: - BackBarButton
    public func backBarButton() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "BT_LeftArrow"), style: .plain, target: self, action: #selector(popView))
    }

    @objc func popView() {
        self.navigationController?.popViewController(animated: true)
    }
}
