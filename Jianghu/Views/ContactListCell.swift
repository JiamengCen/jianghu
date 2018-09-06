//
//  ContactListCell.swift
//  Jianghu
//
//  Created by Jiameng Cen on 8/8/18.
//  Copyright © 2018 InternationalTradeMaster. All rights reserved.
//

import UIKit

class ContactListCell: UITableViewCell {

    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var useImg: UIImageView!
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
