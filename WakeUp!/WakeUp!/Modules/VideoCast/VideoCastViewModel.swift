//
//  VideoCastViewModel.swift
//  WakeUp!
//
//  Created by 강민석 on 2020/11/24.
//

import RxSwift
import RxCocoa

class VideoCastViewModel: BaseViewModel {
    
    let channelID: String
    
    init(channelID: String) {
        self.channelID = channelID
    }
    
    struct Input {
        
    }
    
    struct Output {
        let channelID: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        
        
        
        return Output(channelID: Driver.just(channelID))
    }
}
