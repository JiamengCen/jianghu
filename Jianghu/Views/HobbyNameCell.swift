//
//  HobbyNameCell.swift
//  Jianghu
//
//  Created by WANG, Yanqi on 2018/3/21.
//  Copyright © 2018年 InternationalTradeMaster. All rights reserved.
//

import UIKit

class HobbyNameCell: UICollectionViewCell {

    @IBOutlet weak var hobbyNameLable: UILabel!
    
    override var isSelected: Bool{
        didSet{
            if self.isSelected
            {
                hobbyNameLable.textColor=UIColor.lightGray
            }
            else
            {
                hobbyNameLable.textColor=UIColor.black
            }
        }
    }
    
}
