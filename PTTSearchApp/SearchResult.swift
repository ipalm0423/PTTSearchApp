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
    @NSManaged var account:String!
    @NSManaged var name:String?
    
    //article
    @NSManaged var title:String?
    @NSManaged var postTime:NSDate?
    @NSManaged var picture:NSData?
    
    //profile
    @NSManaged var score:NSNumber?
    @NSManaged var lastOnline:NSDate?
    @NSManaged var osArticle:NSNumber?
    @NSManaged var ofArticle:NSNumber?
    @NSManaged var totalArticle:NSNumber?
    @NSManaged var follower:NSNumber?
    @NSManaged var greenPush:NSNumber?
    @NSManaged var redPush:NSNumber?
    
    
}