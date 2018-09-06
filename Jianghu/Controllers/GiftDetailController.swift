//
//  GiftDetailController.swift
//  Jianghu
//
//  Created by Jiameng Cen on 26/7/18.
//  Copyright © 2018 InternationalTradeMaster. All rights reserved.
//

import UIKit

class GiftDetailController: UIViewController {

    var giftActivityController = GiftActivityController()
    @IBOutlet weak var giftDescription: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var UserImg: UIImageView!
    @IBOutlet weak var bottomImg: UIImageView!
    @IBOutlet weak var topImg: UIImageView!
    var activity:Activity?

    @IBOutlet weak var likeImg: UIImageView!
    @IBAction func like(_ sender: Any) {
        if(likeImg.image==UIImage(named: "hobby")){
            likeImg.image=UIImage(named: "兴趣选中")
        }
        else{
            likeImg.image=UIImage(named: "hobby")
        }
    }
    @IBAction func repost(_ sender: Any) {
        
        DispatchQueue.main.async {
            let viewChange=self.storyboard?.instantiateViewController(withIdentifier: "uploadHobby");
            self.present(viewChange!, animated:true, completion:nil)
        }
 }
    
    @IBAction func getGift(_ sender: Any) {
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
                                let alert = UIAlertController(title: "领取成功", message: "前往参与的活动界面获取二维码", preferredStyle: UIAlertControllerStyle.alert)
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
                                let alert = UIAlertController(title: "领取不可重复", message: "前往参与的活动界面获取二维码", preferredStyle: UIAlertControllerStyle.alert)
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
    /* func loadDetail() {
        self.giftDescription.text = 
    }
    func loadGiftDetail(cate_id:String, type:String){
        guard let url=URL(string: "http://app.meljianghu.com/api/activity/get_by_cate/"+cate_id+"/"+type) else{return}
        let headers = [ "Content-Type": "application/json",
                        "Accept": "application/json"]
        var request=URLRequest(url: url)
        request.httpMethod="GET"
        let session=URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let data=data{
                do {
                    let printString=String(data: data, encoding: String.Encoding.utf8)
                    
                    self.hobbyArticles=try JSONDecoder().decode([HobbyArticle].self, from: data)
                } catch{
                    print(error);
                }
                
            }
            DispatchQueue.main.async {
                self.loading.stopAnimating()
                self.loading.isHidden=true
                self.hobbyContent.isHidden=false
                self.hobbyContent.reloadData();
            }
            }.resume();
    } */

    @IBOutlet weak var giftDetailTitle: UILabel!
    override func viewDidLoad() {
        giftDetailTitle.text = (activity?.title)!
        location.text=(activity?.address)!
        userName.text = (activity?.user_name)!
        time.text=(activity?.start_time)! + " - " + (activity?.end_time)!
        giftDescription.text=activity?.content
        let topLink="https://app.meljianghu.com/storage/"+activity!.img_url_top
        topImg.downloadedFrom(url: topLink)
        topImg.contentMode = .scaleAspectFill
        let bottomLink="https://app.meljianghu.com/storage/"+activity!.img_url_bottom
        bottomImg.downloadedFrom(url: bottomLink)
        bottomImg.contentMode = .scaleAspectFill
        UserImg.layer.cornerRadius=UserImg.frame.height/2
        UserImg.layer.masksToBounds=true
        //selectLike.isHidden=true
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
