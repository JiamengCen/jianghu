//
//  TopicCollectionViewCell.swift
//  Jianghu
//
//  Created by Jiameng Cen on 26/7/18.
//  Copyright © 2018 InternationalTradeMaster. All rights reserved.
//

import UIKit

class TopicCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var topicCollectionName: UILabel!
    override var isSelected: Bool{
        didSet{
            if self.isSelected
            {
                topicCollectionName.textColor=UIColor.lightGray
            }
            else
            {
                topicCollectionName.textColor=UIColor.black
            }
        }
    }
    
}
