//
//  ServiceDetailViewController.swift
//  Jianghu
//
//  Created by Jiameng Cen on 21/7/18.
//  Copyright © 2018 InternationalTradeMaster. All rights reserved.
//

import UIKit

class ServiceDetailViewController: UIViewController {

    @IBOutlet weak var collect: UIImageView!
    @IBOutlet var headImg: UIImageView!
    @IBOutlet weak var imgBottom: UIImageView!
    @IBOutlet weak var publisher: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var activityTitle: UILabel!
    @IBOutlet weak var place: UILabel!
    @IBOutlet weak var time: UILabel!
    
    @IBAction func collectButoon(_ sender: Any) {
        if(collect.image==UIImage(named: "兴趣未选中")){
            collect.image=UIImage(named: "收藏选中")
        }
        else{
            collect.image=UIImage(named: "兴趣未选中")
        }
    }
    @IBOutlet weak var clickCollect: UIButton!
    var activity:Activity?
    override func viewDidLoad() {
        activityTitle.text = (activity?.title)!
        place.text=(activity?.address)!
        //time.text=(activity?.start_time)! + " - " + (activity?.end_time)!
        content.text=activity?.content
        publisher.text = (activity?.user_name)!
        let topLink="https://app.meljianghu.com/storage/"+activity!.img_url_top
        img.downloadedFrom(url: topLink)
        img.contentMode = .scaleAspectFill
        let bottomLink="https://app.meljianghu.com/storage/"+activity!.img_url_bottom
        imgBottom.downloadedFrom(url: bottomLink)
        imgBottom.contentMode = .scaleAspectFill
        headImg.layer.cornerRadius=headImg.frame.height/2
        headImg.layer.masksToBounds=true
        
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
