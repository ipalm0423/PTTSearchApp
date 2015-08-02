//
//  BasicProfileTableViewCell.swift
//  PTTSearchApp
//
//  Created by 陳冠宇 on 2015/8/2.
//  Copyright (c) 2015年 陳冠宇. All rights reserved.
//

import UIKit

class BasicProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImage: UIImageView!
    
    @IBOutlet weak var accountLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var lastOnlineLabel: UILabel!
    
    @IBOutlet weak var areaLabel: UILabel!
    
    
    
    
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
            self.iconImage.image = UIImage(data: data)
        }else {
            self.iconImage.image = Singleton.sharedInstance.setupAvatorImage(self.accountLabel.text, width: 60)
        }
        self.iconImage.layer.cornerRadius = 30
        self.iconImage.clipsToBounds = true
        
    }

}
