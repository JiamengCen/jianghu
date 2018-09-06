//
//  GiftCell.swift
//  Jianghu
//
//  Created by Jiameng Cen on 25/7/18.
//  Copyright © 2018 InternationalTradeMaster. All rights reserved.
//

import UIKit

class GiftCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var headImg: UIImageView!
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var backgroImag: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
