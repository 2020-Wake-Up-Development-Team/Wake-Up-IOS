//
//  VideoCastViewController.swift
//  WakeUp!
//
//  Created by 강민석 on 2020/11/24.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa
import RemoteMonster

class VideoCastViewController: BaseViewController, StoryboardSceneBased {

    static let sceneStoryboard = R.storyboard.videoCast()
    
    @IBOutlet var remonCall: RemonCall!
    var socketErr = false
    
    @IBOutlet weak var channelIDLabel: UILabel!
    @IBOutlet weak var switchCameraButton: UIButton!
    @IBOutlet weak var endCallButton: UIButton!
    @IBOutlet weak var muteVoiceButton: UIButton!
    @IBOutlet weak var cameraOffButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        requestCameraPermission()
    }
    
    func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
            if granted {
                print("Camera: 권한 허용")
            } else {
                print("Camera: 권한 거부")
            }
        })
    }
    
    override func bindViewModel() {
        super.bindViewModel()

        guard let viewModel = viewModel as? VideoCastViewModel else { fatalError("ViewModel: \(self.viewModel!) Casting Error") }
        
        switchCameraButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.remonCall.switchCamera()
            }).disposed(by: rx.disposeBag)
        
        endCallButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.remonCall.closeRemon()
            }).disposed(by: rx.disposeBag)
        
        muteVoiceButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.remonCall.setLocalAudioEnabled(isEnabled: false)
            }).disposed(by: rx.disposeBag)
        
        cameraOffButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.remonCall.setLocalVideoEnabled(isEnabled: false)
            }).disposed(by: rx.disposeBag)
        
        
        let input = VideoCastViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.channelID
            .drive(onNext: { [weak self] channelID in
                self?.initRemonCallbacks(channelID: channelID)
            }).disposed(by: rx.disposeBag)
    }
    
    func initRemonCallbacks(channelID: String) {
//        self.remonCast.userMeta = DatabaseManager.shared.getCurrentUser().username
        self.remonCall.userMeta = "강민석"
        
        self.remonCall.connect(channelID)
        
        self.remonCall.onConnect { [weak self] (chID) in
            self?.endCallButton.isEnabled = true
            self?.channelIDLabel.text = channelID
        }
        
        self.remonCall.onInit { [weak self] in
            self?.socketErr = false
            self?.channelIDLabel.text = "Wait..."
        }
    
        self.remonCall.onStat { [weak self] (report) in
           print(self?.debugDescription ?? "")

            _ = report.remoteFrameRate
            _ = report.localFrameRate

            //            print("remonStat.remoteFrameRate A®" , remoteFrameRate)
        }
        
        self.remonCall.onError { [weak self](error) in
            print("ERROR" , error.localizedDescription)
            if (error.localizedDescription.contains("error 3")){
                self?.remonCall.closeRemon()
                self?.socketErr = true
            }
        }
        
        self.remonCall.onClose { [weak self] (type) in
            if self?.socketErr ?? false {
                self?.socketErr = false
                self?.remonCall.connect(channelID)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
        // 뷰가 pop 되는 경우 sdk를 종료합니다
        self.remonCall?.closeRemon()
    }
}
