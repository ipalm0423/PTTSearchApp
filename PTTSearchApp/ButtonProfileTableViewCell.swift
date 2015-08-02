//
//  ButtonTableViewCell.swift
//  PTTSearchApp
//
//  Created by 陳冠宇 on 2015/8/2.
//  Copyright (c) 2015年 陳冠宇. All rights reserved.
//

import UIKit

class ButtonProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var ArticleButton: UIButton!
    
    @IBOutlet weak var PushButton: UIButton!
    
    @IBOutlet weak var RightPushButtonConst: NSLayoutConstraint!
    
    @IBOutlet weak var LeftPushButtonConst: NSLayoutConstraint!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupButtonWidth() {
        let quarterWidth = self.bounds.width / 4
        self.LeftPushButtonConst.constant = quarterWidth
        self.RightPushButtonConst.constant = -(quarterWidth)
    }
    
    
    
}
