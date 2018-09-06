//
//  MyContactViewCell.swift
//  Jianghu
//
//  Created by WANG, Yanqi on 2018/7/30.
//  Copyright © 2018年 InternationalTradeMaster. All rights reserved.
//

import UIKit

class MyContactViewCell: UITableViewCell {

    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var userImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
