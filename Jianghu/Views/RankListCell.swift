//
//  RankListCell.swift
//  Jianghu
//
//  Created by Jiameng Cen on 19/7/18.
//  Copyright © 2018 InternationalTradeMaster. All rights reserved.
//

import UIKit

class RankListCell: UITableViewCell {
    @IBOutlet weak var userHead: UIImageView!
    
    @IBOutlet weak var creditLogo: UIImageView!
    @IBOutlet weak var nameTitle: UILabel!
    @IBOutlet weak var medal: UIImageView!
    @IBOutlet weak var creditNum: UILabel!
    
   
    override func awakeFromNib() {
        medal.isHidden = true
        super.awakeFromNib()
        self.creditLogo.isHidden=true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
