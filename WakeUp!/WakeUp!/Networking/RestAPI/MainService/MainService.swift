//
//  MainService.swift
//  WakeUp!
//
//  Created by 강민석 on 2020/11/24.
//

import Foundation
import RxSwift
import Moya
import CryptoSwift

final class MainService: BaseService<MainAPI> {
    
    func signIn(id: String, password: String) -> Single<User> {
        requestObject(.signIn(id: id, password: password), type: User.self)
    }
    
    func signUp(id: String, password: String, school: String, schoolClass: String, username: String) -> Single<User> {
        requestObject(.signUp(id: id, password: password, school: school, schoolClass: schoolClass, username: username), type: User.self)
    }
    
}

extension MainService {
    private func requestWithoutMapping(_ target: MainAPI) -> Single<Void> {
        return request(target)
            .map { _ in }
    }
    
    private func requestObject<T: Codable>(_ target: MainAPI, type: T.Type) -> Single<T> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return request(target)
            .map(T.self, using: decoder)
    }
    
    private func requestArray<T: Codable>(_ target: MainAPI, type: T.Type) -> Single<[T]> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return request(target)
            .map([T].self, using: decoder)
    }
}
