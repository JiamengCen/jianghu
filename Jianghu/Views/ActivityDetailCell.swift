//
//  ActivityDetailCell.swift
//  Jianghu
//
//  Created by Jiameng Cen on 25/7/18.
//  Copyright © 2018 InternationalTradeMaster. All rights reserved.
//

import UIKit

class ActivityDetailCell: UICollectionViewCell {
    @IBOutlet weak var name: UILabel!
    
    override var isSelected: Bool{
        didSet{
            if self.isSelected
            {
                name.textColor=UIColor.red
            }
            else
            {
                name.textColor=UIColor.black
            }
        }
    }
    
    
}
