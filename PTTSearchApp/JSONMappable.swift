//
//  JSONMappable.swift
//  PTTSearchApp
//
//  Created by 陳冠宇 on 2015/7/18.
//  Copyright (c) 2015年 陳冠宇. All rights reserved.
//

import Foundation
import ObjectMapper

class mapHint: Mappable {
    var topTopic: [String]?
    var topSearch: [String]?
    var suggestHint: [String]?
    
    init() {}
    
    required init?(_ map: Map) {
        mapping(map)
    }
    
    func mapping(map: Map) {
        topTopic <- map["topTopic"]
        topSearch <- map["topSearch"]
        suggestHint <- map["suggestHint"]
        
    }
}

class WeatherResponse: Mappable {
    var location: String?
    
    
    init() {}
    
    required init?(_ map: Map) {
        mapping(map)
    }
    
    func mapping(map: Map) {
        location <- map["location"]
        
    }
}