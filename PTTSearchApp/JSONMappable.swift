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

class mapContent: Mappable {
    var uid: String?
    var type: String?
    var subType: String?
    var title: String?
    var content: String?
    var account: String?
    var time: NSDate?
    var floor: String?
    var childfloor: String?
    
    
    init() {}
    
    required init?(_ map: Map) {
        mapping(map)
    }
    
    func mapping(map: Map) {
        uid <- map["uid"]
        type <- map["type"]
        subType <- map["subType"]
        title <- map["title"]
        content <- map["content"]
        account <- map["account"]
        time <- (map["time"], DateTransform())
        floor <- map["floor"]
        childfloor <- map["childfloor"]
    }
}

class mapTitle: Mappable {
    var uid: String?
    var url: String?
    var ip: String?
    var account: String?
    var name: String?
    var title: String?
    var subTitle: String?
    var board: String?
    var time: NSDate?
    var pushes: String?
    var icon: String?
    var politic: String?
    var motheruid: String?
    var childuid: [String]?
    var tag: [String]?
        
    init() {}
        
    required init?(_ map: Map) {
            mapping(map)
        }
        
    func mapping(map: Map) {
        uid <- map["uid"]
        url <- map["url"]
        ip <- map["ip"]
        account <- map["account"]
        name <- map["name"]
        title <- map["title"]
        subTitle <- map["subTitle"]
        board <- map["board"]
        time <- (map["time"], DateTransform())
        pushes <- map["pushes"]
        icon <- map["icon"]
        politic <- map["politic"]
        motheruid <- map["motheruid"]
        childuid <- map["childuid"]
        tag <- map["tag"]
        
        
        }
}

class mapContents: Mappable {
    var contents: [mapContent]?
    var hint: String?
    
    init() {}
    
    required init?(_ map: Map) {
        mapping(map)
    }
    
    func mapping(map: Map) {
        contents <- map["contents"]
        hint <- map["hint"]
    }
}

class mapTitles: Mappable {
    var titles: [mapTitle]?
    var hint: String?
    
    init() {}
    
    required init?(_ map: Map) {
        mapping(map)
    }
    
    func mapping(map: Map) {
        titles <- map["titles"]
        hint <- map["hint"]
    }
}

class mapProfile: Mappable {
    var uid: String?
    var account: String?
    var name: String?
    var icon: String?
    var score: String?
    var lastOnline: NSDate?
    var ip: String?
    var osArticle: String?
    var ofArticle: String?
    var totalArticle: String?
    var totalPush: String?
    var onlineCount: String?
    var follower: String?
    var redPush: String?
    var greenPush: String?
    var pushList: [mapContent]?
    var articleList: [mapTitle]?
    var commentList: [mapContent]?
    
    
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
        lastOnline <- (map["lastOnline"], DateTransform())
        ip <- map["ip"]
        osArticle <- map["osArticle"]
        ofArticle <- map["ofArticle"]
        totalArticle <- map["totalArticle"]
        totalPush <- map["totalPush"]
        onlineCount <- map["onlineCount"]
        follower <- map["follower"]
        redPush <- map["redPush"]
        greenPush <- map["greenPush"]
        pushList <- map["pushList"]
        articleList <- map["articleList"]
        commentList <- map["commentList"]
        
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