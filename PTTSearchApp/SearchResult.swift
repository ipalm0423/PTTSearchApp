//
//  searchProfile.swift
//  PTTSearchApp
//
//  Created by 陳冠宇 on 2015/7/19.
//  Copyright (c) 2015年 陳冠宇. All rights reserved.
//

import Foundation
import CoreData

class SearchResult: NSManagedObject{
    //basic
    @NSManaged var uid:String!
    @NSManaged var scope:String!
    @NSManaged var account:String?
    @NSManaged var name:String?
    @NSManaged var ip:String?
    @NSManaged var icon:String?
    @NSManaged var saveTime:NSDate!
    
    //title
    @NSManaged var title:String?
    @NSManaged var subTitle:String?
    @NSManaged var board:String?
    @NSManaged var url:String?
    @NSManaged var pushes:String?
    @NSManaged var politic:String?
    @NSManaged var motheruid:String?
    @NSManaged var childuid:NSArray?
    @NSManaged var tag:NSArray?
    @NSManaged var time:NSDate?
    
    //profile
    @NSManaged var score:String?
    @NSManaged var lastOnline:NSDate?
    @NSManaged var osArticle:String?
    @NSManaged var ofArticle:String?
    @NSManaged var totalArticle:String?
    @NSManaged var totalPush:String?
    @NSManaged var onlineCount:String?
    @NSManaged var follower:String?
    @NSManaged var greenPush:String?
    @NSManaged var redPush:String?
    
    
}