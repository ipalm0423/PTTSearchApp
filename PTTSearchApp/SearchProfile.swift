//
//  searchProfile.swift
//  PTTSearchApp
//
//  Created by 陳冠宇 on 2015/7/19.
//  Copyright (c) 2015年 陳冠宇. All rights reserved.
//

import Foundation
import CoreData

class SearchProfile: NSManagedObject{
    @NSManaged var account:String!
    @NSManaged var name:String?
    //@NSManaged var roomID:String?
    @NSManaged var time:NSDate?
    @NSManaged var picture:NSData?
    //summary
    @NSManaged var follower:NSNumber?
    @NSManaged var greenPush:NSNumber?
    @NSManaged var redPush:NSNumber?
    @NSManaged var totalTitle:NSNumber?
    
}