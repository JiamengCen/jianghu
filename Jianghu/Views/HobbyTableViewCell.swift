//
//  HobbyTableViewCell.swift
//  Jianghu
//
//  Created by WANG, Yanqi on 2018/4/29.
//  Copyright © 2018年 InternationalTradeMaster. All rights reserved.
//

import UIKit

class HobbyTableViewCell: UITableViewCell {

   

    @IBOutlet weak var tag2: UILabel!
    
    @IBOutlet weak var img6: UIImageView!
    @IBOutlet weak var img5: UIImageView!
    @IBOutlet weak var img4: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var totalStackHeight: NSLayoutConstraint!
    @IBOutlet weak var imgStack2: UIStackView!
    @IBOutlet weak var imgStack1: UIStackView!
    @IBOutlet weak var user: UILabel!
    @IBOutlet weak var content: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
