//
//  IndicatorTableViewCell.swift
//  PTTSearchApp
//
//  Created by 陳冠宇 on 2015/8/7.
//  Copyright (c) 2015年 陳冠宇. All rights reserved.
//

import UIKit

class IndicatorTableViewCell: UITableViewCell {

    @IBOutlet weak var indicatorLabel: UILabel!
    
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
