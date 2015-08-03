//
//  searchHistory.swift
//  PTTSearchApp
//
//  Created by 陳冠宇 on 2015/7/19.
//  Copyright (c) 2015年 陳冠宇. All rights reserved.
//

import Foundation
import CoreData

class SearchHistroy: NSManagedObject{
    @NSManaged var hint:String!
    @NSManaged var searchTime:NSDate!
    @NSManaged var scope:String!
}