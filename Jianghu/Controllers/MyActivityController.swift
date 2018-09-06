//
//  MyActivityController.swift
//  Jianghu
//
//  Created by WANG, Yanqi on 2018/5/7.
//  Copyright © 2018年 InternationalTradeMaster. All rights reserved.
//

import UIKit

class MyActivityController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var loading: UIActivityIndicatorView!
    @IBOutlet weak var content: UITableView!
    var activities=[Activity]();
    override func viewDidLoad() {
        super.viewDidLoad()
        content.delegate=self
        content.dataSource=self
        loading.isHidden=false
        loading.startAnimating();
        content.isHidden=true
        guard let url = URL(string:"https://app.meljianghu.com/api/activity/my") else {
            return
        }
        var request=URLRequest(url: url)
        request.httpMethod="GET"
        let headers = [ "Content-Type": "application/json",
                        "Accept": "application/json",
                        "Authorization": "Bearer"+" " + UserInfo.token]
        request.allHTTPHeaderFields = headers
        let session=URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let data=data{
                do{
                    let printString=String(data: data, encoding: String.Encoding.utf8)
                    print(printString)
                    self.activities=try JSONDecoder().decode([Activity].self, from: data)
                }catch{
                    print(error);
                }
            }
                DispatchQueue.main.async {
                    self.loading.isHidden=true
                    self.loading.stopAnimating()
                    self.content.isHidden=false
                    self.content.reloadData();
                }
            }.resume();
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return activities.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let activityCell = content.dequeueReusableCell(withIdentifier: "activity") as! ActivityCell
        activityCell.title.text=activities[indexPath.row].title;
        activityCell.time.text = activities[indexPath.row].start_time+" - "+activities[indexPath.row].end_time;
        activityCell.location.text = activities[indexPath.row].address;
        let topLink="https://app.meljianghu.com/storage/"+activities[indexPath.row].img_url_top
        activityCell.img.downloadedFrom(url: topLink)
        activityCell.img.contentMode = .scaleAspectFill
        activityCell.headImg.layer.cornerRadius=activityCell.headImg.frame.height/2;
        activityCell.tagLable.text = activities[indexPath.row].cate_name;
        return activityCell;
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
            self.activities.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /* if tableView==self.activityView{
         performSegue(withIdentifier: "showActivity", sender: self)
         }
         else{
         performSegue(withIdentifier: "showBigActivity", sender: self)
         }*/
        performSegue(withIdentifier: "showMyActivity", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /*if segue.identifier=="showActivity"{
         if let destination=segue.destination as? ActivityDetailController{
         destination.activity=activities[(activityView.indexPathForSelectedRow?.row)!]
         }
         }
         if segue.identifier=="showBigActivity"{
         if let destination=segue.destination as? BigActivityController{
         destination.bigAc=bigActivities[(bigActivityView.indexPathForSelectedRow?.row)!]
         }
         }*/
        
        if let destination=segue.destination as? ActivityDetailController{
            destination.activity=activities[(content.indexPathForSelectedRow?.row)!]
        }
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
