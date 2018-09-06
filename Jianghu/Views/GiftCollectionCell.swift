//
//  GiftCollectionCell.swift
//  Jianghu
//
//  Created by Jiameng Cen on 26/7/18.
//  Copyright © 2018 InternationalTradeMaster. All rights reserved.
//

import UIKit

class GiftCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var giftcollectName: UILabel!
    override var isSelected: Bool{
        didSet{
            if self.isSelected
            {
                giftcollectName.textColor=UIColor.lightGray
            }
            else
            {
                giftcollectName.textColor=UIColor.black
            }
        }
    }
}
