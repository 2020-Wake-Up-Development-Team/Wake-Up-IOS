//
//  MainAPI.swift
//  WakeUp!
//
//  Created by 강민석 on 2020/11/24.
//

import Foundation
import RxSwift
import Moya

enum MainAPI {
    
    // MARK: - Authentication is not required
    case signIn(id: String, password: String)
    case signUp(id: String, password: String, school: String, schoolClass: String, username: String)
    
}

extension MainAPI: BaseAPI {
    var path: String {
        switch self {
        case .signIn:
            return "/auth/login"
        case .signUp:
            return "/auth/signup"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signIn, .signUp:
            return .post
        }
    }
    
    var headers: [String: String]? {
        switch self {
        // None Authentication
        case .signIn, .signUp:
            break
        // Authentication
//        default:
//            return ["Authentication": TokenManager.shared.token!]
        }
        return nil
    }
    
    var task: Task {
        switch self {
        default:
            if let parameters = parameters {
                return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            }
            return .requestPlain
        }
    }
    
    var parameters: [String: Any]? {
        var params: [String: Any] = [:]
        switch self {
        case .signIn(let id, let password):
            params["id"] = id
            params["pwd"] = password
        case .signUp(let id, let password, let school, let schoolClass, let username):
            params["id"] = id
            params["pwd"] = password
            params["school"] = school
            params["class"] = schoolClass
            params["name"] = username
        }
        return params
    }
}
