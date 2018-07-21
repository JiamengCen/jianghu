//
//  activityNavCell.swift
//  Jianghu
//
//  Created by WANG, Yanqi on 2018/5/3.
//  Copyright © 2018年 InternationalTradeMaster. All rights reserved.
//

import UIKit

class activityNavCell: UICollectionViewCell {
    
    @IBOutlet weak var name: UILabel!
    
    override var isSelected: Bool{
        didSet{
            if self.isSelected
            {
                name.textColor=UIColor.lightGray
            }
            else
            {
                name.textColor=UIColor.black
            }
        }
    }
}
