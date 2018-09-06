//
//  GroupDiscussCell.swift
//  Jianghu
//
//  Created by Jiameng Cen on 23/7/18.
//  Copyright © 2018 InternationalTradeMaster. All rights reserved.
//

import UIKit

class GroupDiscussCell: UITableViewCell {

    @IBOutlet weak var groupTag: UILabel!
    @IBOutlet weak var ownerName: UILabel!
    @IBOutlet weak var discriptionText: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var OwnerheadImg: UIImageView!
    @IBOutlet weak var groupImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
