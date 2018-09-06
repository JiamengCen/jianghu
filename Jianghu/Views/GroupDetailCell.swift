//
//  GroupDetailCell.swift
//  Jianghu
//
//  Created by Jiameng Cen on 20/7/18.
//  Copyright © 2018 InternationalTradeMaster. All rights reserved.
//

import UIKit

class GroupDetailCell: UITableViewCell {

    @IBOutlet weak var myMessages: UILabel!
    @IBOutlet weak var triangleyellow: UIImageView!
    @IBOutlet weak var myHead: UIImageView!
    @IBOutlet weak var othersMessages: UILabel!
    @IBOutlet weak var trianglewhite: UIImageView!
    @IBOutlet weak var otherHeads: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
