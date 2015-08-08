//
//  PushTableViewCell.swift
//  PTTSearchApp
//
//  Created by 陳冠宇 on 2015/8/2.
//  Copyright (c) 2015年 陳冠宇. All rights reserved.
//

import UIKit

class PushTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var pushLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupPushLabelColor() {
        if let count = self.pushLabel.text?.toInt() {
            if count > 0 {
                self.pushLabel.textColor = UIColor.redColor()
            }else if count < 0 {
                self.pushLabel.textColor = UIColor.greenColor()
            }
        }
    }
    

}
