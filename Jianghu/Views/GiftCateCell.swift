

//
//  GiftCateCell.swift
//  Jianghu
//
//  Created by Jiameng Cen on 26/7/18.
//  Copyright © 2018 InternationalTradeMaster. All rights reserved.
//

import UIKit

class GiftCateCell: UICollectionViewCell {
    
    @IBOutlet weak var giftCateName: UILabel!
    
    override var isSelected: Bool{
        didSet{
            if self.isSelected
            {
                giftCateName.textColor=UIColor.lightGray
            }
            else
            {
                giftCateName.textColor=UIColor.black
            }
        }
    }
    
}
