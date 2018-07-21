//
//  JoinedActivityController.swift
//  Jianghu
//
//  Created by WANG, Yanqi on 2018/5/16.
//  Copyright © 2018年 InternationalTradeMaster. All rights reserved.
//

import UIKit

class JoinedActivityController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let activityCell = content.dequeueReusableCell(withIdentifier: "activity") as! ActivityCell
        activityCell.title.text=activities[indexPath.row].title;
        activityCell.time.text=activities[indexPath.row].times
        activityCell.location.text=activities[indexPath.row].place;
        activityCell.img.downloadedFrom(link: "http://jhapp.com.au/"+activities[indexPath.row].img)
        activityCell.img.contentMode = .scaleAspectFill
        activityCell.headImg.layer.cornerRadius=activityCell.headImg.frame.height/2;
        // activityCell.hotButton.layer.cornerRadius=5;
        return activityCell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showQR", sender: self)
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
        
        if let destination=segue.destination as? QRPageController{
            destination.activity=activities[(content.indexPathForSelectedRow?.row)!]
        }
    }
    
    var activities = [Activity]();
    
    
    @IBOutlet weak var content: UITableView!
    override func viewDidLoad() {
        content.delegate=self
        content.dataSource=self
        super.viewDidLoad()

        
        
        guard let url=URL(string: "http://jhapp.com.au/display_joined_activity.php") else{return}
        var request=URLRequest(url: url)
        request.httpMethod="POST"
        let para="user="+UserInfo.id;
        request.httpBody=para.data(using: String.Encoding.utf8);
        let session=URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let data=data{
                do{
                    self.activities=try JSONDecoder().decode([Activity].self, from: data)
                    
                }catch{
                    print(error);
                }
                
            }
            DispatchQueue.main.async {
                self.content.reloadData();
            }
        }.resume();
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
