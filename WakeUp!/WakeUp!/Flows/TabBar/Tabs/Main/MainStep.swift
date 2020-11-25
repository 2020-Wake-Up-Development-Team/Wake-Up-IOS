//
//  MainStep.swift
//  WakeUp!
//
//  Created by 강민석 on 2020/11/24.
//

import RxFlow

enum MainStep: Step {
    case mainIsRequired
    case createClassIsRequired
    case joinClassIsRequired
    
    case videoCastIsRequired(channelID: String)    
    
    case popViewController
}
