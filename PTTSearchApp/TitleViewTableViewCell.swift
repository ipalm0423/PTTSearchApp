//
//  TitleViewTableViewCell.swift
//  PTTSearchApp
//
//  Created by 陳冠宇 on 2015/8/2.
//  Copyright (c) 2015年 陳冠宇. All rights reserved.
//

import UIKit

class TitleViewTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var accountLabel: UILabel!
    
    @IBOutlet weak var subTitleLabel: UILabel!
    
    @IBOutlet weak var pushLabel: UILabel!
    
    @IBOutlet weak var iconImage: UIImageView!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var boardLabel: UILabel!
    
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
            self.iconImage.image = Singleton.sharedInstance.setupAvatorImage(self.accountLabel.text, width: 50)
        }
        self.iconImage.layer.cornerRadius = 25
        self.iconImage.clipsToBounds = true
        
    }

}
