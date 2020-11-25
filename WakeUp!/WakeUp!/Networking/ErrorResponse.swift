//
//  ErrorResponse.swift
//  WakeUp!
//
//  Created by 강민석 on 2020/11/24.
//

import Foundation

struct ErrorResponse: Decodable, Error {
    var status: Int?
    let message: String
}
