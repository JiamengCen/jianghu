//
//  ActivityDetailController.swift
//  Jianghu
//
//  Created by WANG, Yanqi on 2018/4/27.
//  Copyright © 2018年 InternationalTradeMaster. All rights reserved.
//

import UIKit

class ActivityDetailController: UIViewController {

    @IBOutlet weak var popUpWindow: UIView!
    @IBOutlet var headImg: UIImageView!
    @IBOutlet weak var imgBottom: UIImageView!
    @IBOutlet weak var publisher: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var activityTitle: UILabel!
    @IBOutlet weak var place: UILabel!
    @IBOutlet weak var time: UILabel!
    //private var customView: UIView!
    //var myActivity:JoinActivity?
    var activity:Activity?
    override func viewDidLoad() {
        activityTitle.text = (activity?.title)!
        publisher.text=(activity?.title)!
        place.text=(activity?.address)!
        time.text=(activity?.start_time)! + " - " + (activity?.end_time)!
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
        //customView.isHidden = true

        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBOutlet weak var likeImg: UIImageView!
    @IBAction func likeClick(_ sender: Any) {
        if(likeImg.image==UIImage(named: "hobby")){
           likeImg.image=UIImage(named: "兴趣选中")
            }
        else{
            likeImg.image=UIImage(named: "hobby")
        }
        
    }
    @IBOutlet weak var like: UIButton!
    @IBAction func jionActivity(_ sender: Any) {
        
        //let data=UploadHobby(content: contentView.text!, image_url: img_array, collection_id:String( selectedCollection!.id), cate_id: String(selectedCategory!.id))
        //let data="{ 'activity_id': "
        if(UserInfo.token != ""){
            let data=JoinActivityData(activity_id: String( activity!.id))
            let encoder=JSONEncoder();
            
            encoder.outputFormatting = .prettyPrinted
            let json=try? encoder.encode(data)
            print(String(data: json!, encoding: .utf8)!)
            guard let url=URL(string: "https://app.meljianghu.com/api/activity/join") else{return}
            let headers = [ "Content-Type": "application/json",
                            "Accept": "application/json",
                            "Authorization": "Bearer"+" " + UserInfo.token ]
            var request=URLRequest(url: url)
            request.httpMethod="POST"
            let para=String(data: json!, encoding: .utf8)
            request.httpBody = para!.data(using: String.Encoding.utf8);
            request.allHTTPHeaderFields = headers;
            let session=URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if let data=data{
                    do {
                        let printString=String(data: data, encoding: String.Encoding.utf8)
                        print(printString)
                        let reply = try JSONDecoder().decode(Reply.self, from: data)
                        if(reply.message=="success"){
                            DispatchQueue.main.async {
                                // create the alert
                                let alert = UIAlertController(title: "报名成功", message: "前往参与的活动界面获取二维码", preferredStyle: UIAlertControllerStyle.alert)
                                // add the actions (buttons)
                                alert.addAction(UIAlertAction(title: "完成", style: UIAlertActionStyle.default, handler: nil))
                                alert.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil))
                                // show the alert
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                        else{
                            DispatchQueue.main.async {
                                // create the alert
                                let alert = UIAlertController(title: "报名不可重复", message: "前往参与的活动界面获取二维码", preferredStyle: UIAlertControllerStyle.alert)
                                // add the actions (buttons)
                                alert.addAction(UIAlertAction(title: "了解", style: UIAlertActionStyle.default, handler: nil))
                                alert.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil))
                                // show the alert
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    } catch{
                        print(error);
                    }
                }
                }.resume();
         
        }
        else{
            let viewChange=self.storyboard?.instantiateViewController(withIdentifier: "login");
            self.show(viewChange!, sender: self)
        }
    }
}



