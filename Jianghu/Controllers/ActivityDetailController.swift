//
//  ActivityDetailController.swift
//  Jianghu
//
//  Created by WANG, Yanqi on 2018/4/27.
//  Copyright © 2018年 InternationalTradeMaster. All rights reserved.
//

import UIKit

class ActivityDetailController: UIViewController {

    

    @IBOutlet weak var imgBottom: UIImageView!
    @IBOutlet weak var publisher: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var activityTitle: UILabel!
    @IBOutlet weak var place: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBAction func JoinActivity(_ sender: Any) {
        if(UserInfo.ifLogin){
            let para="user="+UserInfo.id+"&activity="+(activity?.id)!;
            guard let url=URL(string: "http://jhapp.com.au/join_Action.php") else{return}
            var request=URLRequest(url: url)
            request.httpMethod="POST"
            request.httpBody=para.data(using: String.Encoding.utf8);
            let session=URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if let data=data{
                    guard let result = try? JSONSerialization.jsonObject(with: data, options:[]) as? [String:
                        Any] else{
                            print("Error: Couldn't decode data ")
                            return
                    }
                    DispatchQueue.main.async {
                        if result?["reply"] as! String=="SUCCESS"{
                            let alert = UIAlertController(title: "提示", message: "报名成功", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                        else{
                            let alert = UIAlertController(title: "提示", message: "报名失败", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }.resume();
            
            
        }
        else{
            let viewChange=self.storyboard?.instantiateViewController(withIdentifier: "login");
            self.show(viewChange!, sender: self)
        }
    }
    var activity:Activity?
    override func viewDidLoad() {
        activityTitle.text = (activity?.title)!
        place.text=(activity?.place)!
        time.text=(activity?.times)!
        publisher.text=(activity?.user_name)!
        //phone.text=(activity?.phone)!
        content.text=activity?.content
       // img.downloadedFrom(link: "http://jhapp.com.au/"+(activity?.img)!)
        img.contentMode = .scaleAspectFill
        imgBottom.downloadedFrom(link: "http://jhapp.com.au/"+(activity?.img)!)
        imgBottom.contentMode = .scaleAspectFill
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
