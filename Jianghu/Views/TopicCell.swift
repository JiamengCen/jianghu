//
//  TopicCell.swift
//  Jianghu
//
//  Created by WANG, Yanqi on 2018/5/4.
//  Copyright © 2018年 InternationalTradeMaster. All rights reserved.
//

import UIKit

class TopicCell: UITableViewCell {

 
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var tag2: UILabel!
    @IBOutlet weak var tag1: UILabel!
    @IBOutlet weak var user: UILabel!
    @IBOutlet weak var titleName: UILabel!
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        let mScreenSize = UIScreen.main.bounds
        let mSeparatorHeight = CGFloat(4.0) // Change height of speatator as you want
        let mAddSeparator = UIView.init(frame: CGRect(x: 0, y: self.frame.size.height - mSeparatorHeight, width: mScreenSize.width, height: mSeparatorHeight))
        mAddSeparator.backgroundColor = UIColor.white // Change backgroundColor of separator
        self.addSubview(mAddSeparator)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
