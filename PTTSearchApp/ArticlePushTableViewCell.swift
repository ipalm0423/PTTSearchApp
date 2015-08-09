//
//  ArticlePushTableViewCell.swift
//  PTTSearchApp
//
//  Created by 陳冠宇 on 2015/8/8.
//  Copyright (c) 2015年 陳冠宇. All rights reserved.
//

import UIKit

class ArticlePushTableViewCell: UITableViewCell {

    @IBOutlet weak var accountLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var floorLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupPushLabelColor(type: String) {
        switch type {
            case "red":
            self.contentLabel.textColor = UIColor.redColor()
            case "green":
            self.contentLabel.textColor = UIColor.greenColor()
        default:
            self.contentLabel.textColor = UIColor.blackColor()
        }
    }
    
    
}
