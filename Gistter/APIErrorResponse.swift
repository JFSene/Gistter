//
//  APIErrorResponse.swift
//  NetworkingArchitectureExample
//
//  Created by Joel Sene on 4/4/17.
//  Copyright © 2017 Joel Sene. All rights reserved.
//

import Foundation
import ObjectMapper

struct APIErrorResponse: Mappable {
    var code: Int?
    var message: String?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        code <- map["code"]
        message <- map["message"]
    }
}
