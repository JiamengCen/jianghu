//
//  ActivityCell.swift
//  Jianghu
//
//  Created by WANG, Yanqi on 2018/4/26.
//  Copyright © 2018年 InternationalTradeMaster. All rights reserved.
//

import UIKit

class ActivityCell: UITableViewCell {

    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var title: UILabel!

    @IBOutlet weak var headImg: UIImageView!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var location: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
