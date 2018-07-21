//
//  MyActivityController.swift
//  Jianghu
//
//  Created by WANG, Yanqi on 2018/5/7.
//  Copyright © 2018年 InternationalTradeMaster. All rights reserved.
//

import UIKit

class MyActivityController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var content: UITableView!
    var activities=[Activity]();
    override func viewDidLoad() {
        super.viewDidLoad()
        content.delegate=self
        content.dataSource=self
        
        guard let url = URL(string:"http://jhapp.com.au/displayUserActivity.php"+"?id="+UserInfo.id) else {
            return
        }
        let session=URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let response=response{
                print(response);
            }
            if let data=data{
                do{
                    self.activities=try JSONDecoder().decode([Activity].self, from: data)
                }catch{
                    print(error);
                }
                DispatchQueue.main.async {
                    self.content.reloadData();
                }
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
        activityCell.time.text=activities[indexPath.row].times
        activityCell.location.text=activities[indexPath.row].place;
        activityCell.img.downloadedFrom(link: "http://jhapp.com.au/"+activities[indexPath.row].img)
        activityCell.img.contentMode = .scaleAspectFill
        activityCell.headImg.layer.cornerRadius=activityCell.headImg.frame.height/2;
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
