//
//  BaseService.swift
//  WakeUp!
//
//  Created by 강민석 on 2020/11/24.
//

import Moya
import RxSwift

/// 네트워크 호출 상속용
/// https://github.com/Moya/Moya
class BaseService<API: TargetType> {
    
    // 커스텀 로깅 플러그인
    private let provider = MoyaProvider<API>(plugins: [RequestLoggingPlugin()])
    
    /// 네트워크 호출
    /// help from https://github.com/Moya/Moya/issues/1177#issuecomment-345132374
    func request(_ api: API) -> Single<Response> {
        return provider.rx.request(api)
            .flatMap { response in
                if (200...299) ~= response.statusCode {
                    return Single.just(response)
                }
                
                if var error = try? response.map(ErrorResponse.self) {
                    error.status = response.statusCode
                    return Single.error(error)
                }
                
                let genericError = ErrorResponse(
                    status: response.statusCode,
                    message: "Empty Message")
                return Single.error(genericError)
            }
            .filterSuccessfulStatusCodes()
//            .retryWhen { (error: Observable<TokenError>) in
//                error.flatMap { error -> Single<Response> in
//                    AuthService.shared.renewalToken(refreshToken: AuthManager.getRefreshToken()) // 토큰 재발급 받기
//                }
//            }
//            .handleResponse()
//            .filterSuccessfulStatusCodes()
//            .retry(2)
    }
}
