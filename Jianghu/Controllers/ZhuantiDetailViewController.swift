//
//  ZhuantiDetailViewController.swift
//  Jianghu
//
//  Created by Jiameng Cen on 23/7/18.
//  Copyright © 2018 InternationalTradeMaster. All rights reserved.
//

import UIKit

class ZhuantiDetailViewController: UIViewController {
  
    
    @IBOutlet weak var tag: UILabel!
    @IBOutlet var headImg: UIImageView!
    @IBOutlet weak var imgBottom: UIImageView!
    @IBOutlet weak var publisher: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var activityTitle: UILabel!
    @IBOutlet weak var place: UILabel!
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var heart: UIImageView!
    @IBAction func likeClick(_ sender: Any) {
        if(heart.image==UIImage(named: "心1")){
            heart.image=UIImage(named: "心选中")
            let data = ActivityLike(activity_id: String(activity!.id))
            
            let encoder=JSONEncoder();
            encoder.outputFormatting = .prettyPrinted
            let json=try? encoder.encode(data)
            print(String(data: json!, encoding: .utf8)!)
            guard let url=URL(string: "https://app.meljianghu.com/api/like/activity/post") else{return}
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
                            print("success")
                            DispatchQueue.main.async {
                                
                            }
                        }
                        else{
                            print("unsuccess")
                            DispatchQueue.main.async {
                                
                            }
                        }
                    } catch{
                        print(error);
                    }
                }
                }.resume();
            //print("bbbbbbbb")
            } else {
            heart.image=UIImage(named: "心1")
            let data = ActivityLike(activity_id: String(activity!.id))
            let encoder=JSONEncoder();
            encoder.outputFormatting = .prettyPrinted
            let json=try? encoder.encode(data)
            print(String(data: json!, encoding: .utf8)!)
            guard let url=URL(string: "https://app.meljianghu.com/api/like/activity/delete") else{return}
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
                            print("success")
                            DispatchQueue.main.async {
                                
                            }
                        }
                        else{
                            print("unsuccess")
                            DispatchQueue.main.async {
                                
                            }
                        }
                    } catch{
                        print(error);
                    }
                }
                }.resume();
            print("xxxxx")
               }
    }
    
    @IBAction func comment(_ sender: Any) {
        if(UserInfo.token != ""){
            performSegue(withIdentifier: "showTopicComment", sender: sender)
        }
        else{
            let viewChange=self.storyboard?.instantiateViewController(withIdentifier: "login");
            self.show(viewChange!, sender: self)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showTopicComment"){
            if let destination=segue.destination as? TopicCommentController{
                destination.topicActivity=activity
            }
        }
    }
    var activity:Activity?
    override func viewDidLoad() {
        activityTitle.text = (activity?.title)!
        place.text=(activity?.address)!
        time.text=(activity?.start_time)! + " - " + (activity?.end_time)!
        tag.text = (activity?.collection_name)!
        publisher.text = (activity?.user_name)!
        content.text=activity?.content
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
