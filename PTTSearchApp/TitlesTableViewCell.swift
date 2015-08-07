//
//  TitlesTableViewCell.swift
//  PTTSearchApp
//
//  Created by 陳冠宇 on 2015/8/4.
//  Copyright (c) 2015年 陳冠宇. All rights reserved.
//

import UIKit

class TitlesTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var accountLabel: UILabel!
    
    @IBOutlet weak var subLabel: UILabel!
    
    @IBOutlet weak var pushLabel: UILabel!
    
    @IBOutlet weak var boardLabel: UILabel!
    
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupIcon(image: NSData?) {
        if let data = image {
            self.icon.image = UIImage(data: data)
        }else {
            self.icon.image = Singleton.sharedInstance.setupAvatorImage(self.accountLabel.text, width: 50)
        }
        self.icon.layer.cornerRadius = 25
        self.icon.clipsToBounds = true
        
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
