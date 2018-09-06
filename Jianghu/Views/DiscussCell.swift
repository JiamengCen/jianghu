//
//  DiscussCell.swift
//  Jianghu
//
//  Created by Jiameng Cen on 19/7/18.
//  Copyright © 2018 InternationalTradeMaster. All rights reserved.
//

import UIKit

class DiscussCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var ImageHead: UIImageView!
    @IBOutlet weak var message: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
