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
    var serverURL = "http://192.168.1.107:3000/"
    
    
    
    
    
    
    
    
//image func
    func setupAvatorImage(name: String?, width: CGFloat) -> UIImage {
        var colorhash = 1
        
        if name != nil {
            colorhash = name!.hash
        }
        let r = CGFloat(Float((colorhash & 0xFF0000) >> 16)/255.0)
        let g = CGFloat(Float((colorhash & 0xFF00) >> 8)/255.0)
        let b = CGFloat(Float(colorhash & 0xFF)/255.0)
        let color = UIColor(red: r, green: g, blue: b, alpha: 0.3)
        var rect = CGRectMake(0, 0, width, width)
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, width), false, 0)
        color.setFill()
        UIRectFill(rect)
        var image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    
//TIME
    //time parameter
    let dateFormatterString = "yyyy-MM-ddTHH:mm:ss.SSSZ"
    let dateFormatterTWString = "MM/dd HH:mm"
    let dateFormatterDate = "MM/dd"
    let locale = NSLocale(localeIdentifier: "zh_Hant_TW")
    var dateFormater = NSDateFormatter()
    //transfer time to NSDate
    func stringToNSDate(string: String) -> NSDate {
        if string != "" {
            self.dateFormater.dateFormat = self.dateFormatterString
            return self.dateFormater.dateFromString(string)!
        }
        return NSDate()
    }
    //translate NSDate to Chinese String
    func NSDateToTWString(date: NSDate) -> String {
        self.dateFormater.dateFormat = self.dateFormatterTWString
        return self.dateFormater.stringFromDate(date)
    }
    func NSDateToDaysString(date: NSDate) -> String {
        self.dateFormater.dateFormat = self.dateFormatterDate
        return self.dateFormater.stringFromDate(date)
    }
    
}