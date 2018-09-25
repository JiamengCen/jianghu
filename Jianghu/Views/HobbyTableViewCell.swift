//
//  HobbyTableViewCell.swift
//  Jianghu
//
//  Created by WANG, Yanqi on 2018/4/29.
//  Copyright © 2018年 InternationalTradeMaster. All rights reserved.
//

import UIKit

class HobbyTableViewCell: UITableViewCell {

    @IBOutlet weak var repostLabel: UILabel!
    @IBOutlet weak var repostImg: UIImageView!
    @IBOutlet weak var chatButton: UIButton!
    
    @IBOutlet weak var likeText: UILabel!
    @IBOutlet weak var likeImg: UIImageView!
    @IBAction func repost(_ sender: Any) {
    }
    var imgs=Array<UIImageView>();
    var imgCount=0;
   
    @IBOutlet weak var unlikeButton: UIButton!
    //var hobby:HobbyArticle?
    @IBAction func changeLike(_ sender: Any) {
        if(likeText.text=="点赞"){
            likeText.text = "已赞"
            likeText.textColor=UIColor.red
            likeImg.image=UIImage(named: "点赞选中")
             
        }
        else{
            likeText.text = "点赞"
            likeText.textColor=UIColor.lightGray
            likeImg.image=UIImage(named: "点赞未选中")
        }
    }
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var bestMan: UIView!
    @IBOutlet var head: UIImageView!

    @IBOutlet weak var cate: UILabel!
    
    @IBOutlet weak var reportButton: UIButton!
    
    @IBOutlet weak var img6: UIImageView!
    @IBOutlet weak var img5: UIImageView!
    @IBOutlet weak var img4: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var totalStackHeight: NSLayoutConstraint!
    @IBOutlet weak var imgStack2: UIStackView!
    @IBOutlet weak var imgStack1: UIStackView!
    @IBOutlet weak var user: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
