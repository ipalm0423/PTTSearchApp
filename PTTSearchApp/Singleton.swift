//
//  Singleton.swift
//  PTTSearchApp
//
//  Created by 陳冠宇 on 2015/7/18.
//  Copyright (c) 2015年 陳冠宇. All rights reserved.
//

import Foundation
import UIKit
import SugarRecord

class Singleton: NSObject {
    
    class var sharedInstance: Singleton {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: Singleton? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = Singleton()
        }
        return Static.instance!
    }
    
    //Internet
    var serverURL = "http://122.116.90.83:30000"
    
    
}