//
//  BaseAPI.swift
//  WakeUp!
//
//  Created by 강민석 on 2020/11/24.
//

import Foundation
import Moya

protocol BaseAPI: TargetType { }

extension BaseAPI {
    var baseURL: URL { Configs.Network.baseURL }
    
    var method: Moya.Method { .get }
    
    var sampleData: Data { Data() }
    
    var task: Task { .requestPlain }
    
    var headers: [String: String]? { nil }
}
