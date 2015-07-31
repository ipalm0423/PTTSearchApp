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

class mapProfile: Mappable {
    var uid: String?
    var account: String?
    var name: String?
    var icon: String?
    var score: String?
    var lastOnline: String?
    var osArticle: String?
    var ofArticle: String?
    var totalArticle: String?
    var follower: String?
    var redPush: String?
    var greenPush: String?
    
    init() {}
    
    required init?(_ map: Map) {
        mapping(map)
    }
    
    func mapping(map: Map) {
        uid <- map["uid"]
        account <- map["account"]
        name <- map["name"]
        icon <- map["icon"]
        score <- map["score"]
        lastOnline <- map["lastOnline"]
        osArticle <- map["osArticle"]
        ofArticle <- map["ofArticle"]
        totalArticle <- map["totalArticle"]
        follower <- map["follower"]
        redPush <- map["redPush"]
        greenPush <- map["greenPush"]
        
        
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