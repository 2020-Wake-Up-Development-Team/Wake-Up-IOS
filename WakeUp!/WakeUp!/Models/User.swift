//
//  User.swift
//  WakeUp!
//
//  Created by 강민석 on 2020/11/24.
//

import Foundation
import RealmSwift

class User: Object, Codable {
    @objc dynamic var id: String = ""
    @objc dynamic var school: String = ""
    @objc dynamic var schoolClass: String = ""
    @objc dynamic var username: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case school
        case schoolClass = "number"
        case username = "name"
    }
}
