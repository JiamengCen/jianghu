//
//  ServiceCell.swift
//  Jianghu
//
//  Created by Jiameng Cen on 26/7/18.
//  Copyright © 2018 InternationalTradeMaster. All rights reserved.
//

import UIKit

class ServiceCell: UICollectionViewCell {
    
 
    @IBOutlet weak var serviceCatename: UILabel!
    override var isSelected: Bool{
        didSet{
            if self.isSelected
            {
                serviceCatename.textColor=UIColor.lightGray
            }
            else
            {
                serviceCatename.textColor=UIColor.black
            }
        }
    }
    
}
