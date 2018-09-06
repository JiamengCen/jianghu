//
//  TopicCateViewCell.swift
//  Jianghu
//
//  Created by Jiameng Cen on 26/7/18.
//  Copyright © 2018 InternationalTradeMaster. All rights reserved.
//

import UIKit

class TopicCateViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var topicCateName: UILabel!
    override var isSelected: Bool{
        didSet{
            if self.isSelected
            {
                topicCateName.textColor=UIColor.lightGray
            }
            else
            {
                topicCateName.textColor=UIColor.black
            }
        }
    }
}
