//
//  ActivityController.swift
//  Jianghu
//
//  Created by WANG, Yanqi on 2018/4/16.
//  Copyright © 2018年 InternationalTradeMaster. All rights reserved.
//
//
//  ActivityController.swift
//  Jianghu
//
//  Created by WANG, Yanqi on 2018/4/16.
//  Copyright © 2018年 InternationalTradeMaster. All rights reserved.
//

import UIKit

class ActivityController:UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return navNames.count
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = activityNavView.dequeueReusableCell(withReuseIdentifier: "navCell", for: indexPath) as! activityNavCell
        cell.name.text=navNames[indexPath.row]
        return cell;
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedActivities.removeAll();
        for activity in validActivities{
            if(activity.category==navNames[indexPath.row]){
                if(self.if_big==true){
                    if(activity.if_big=="1"){
                        selectedActivities.append(activity)
                    }
                }
                else{
                    if(activity.if_big=="0"){
                        selectedActivities.append(activity)
                    }
                }
                
            }
        }
        activityView.reloadData();
    }
    
    @IBOutlet weak var navTitle: UINavigationItem!
    @IBOutlet weak var activityNavView: UICollectionView!
    @IBOutlet weak var activityView: UITableView!
    var if_big=false;
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*if tableView==self.activityView{
            return activities.count;
        }
        else{
            return bigActivities.count;
        }*/
         return selectedActivities.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*if tableView==self.activityView{
            let activityCell = activityView.dequeueReusableCell(withIdentifier: "activity") as! ActivityCell
            activityCell.title.text=activities[indexPath.row].title;
            activityCell.user.text=activities[indexPath.row].user_name;
            activityCell.location.text=activities[indexPath.row].place;
            return activityCell;
        }
        else{
            let bigActivityCell=bigActivityView.dequeueReusableCell(withIdentifier: "bigActivity") as! BigActivityCell
            bigActivityCell.title.text=bigActivities[indexPath.row].title;
            bigActivityCell.location.text=bigActivities[indexPath.row].place;
            return bigActivityCell;
        }*/
        let activityCell = activityView.dequeueReusableCell(withIdentifier: "activity") as! ActivityCell
        activityCell.title.text=selectedActivities[indexPath.row].title;
        activityCell.time.text=selectedActivities[indexPath.row].times
        activityCell.location.text=selectedActivities[indexPath.row].place;
        activityCell.img.downloadedFrom(link: "http://jhapp.com.au/"+selectedActivities[indexPath.row].img)
        activityCell.img.contentMode = .scaleAspectFill
        activityCell.headImg.layer.cornerRadius=activityCell.headImg.frame.height/2;
       // activityCell.hotButton.layer.cornerRadius=5;
        return activityCell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       /* if tableView==self.activityView{
             performSegue(withIdentifier: "showActivity", sender: self)
        }
        else{
             performSegue(withIdentifier: "showBigActivity", sender: self)
        }*/
        performSegue(withIdentifier: "showActivity", sender: self)
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
            destination.activity=selectedActivities[(activityView.indexPathForSelectedRow?.row)!]
        }
    }
    
    
    @IBAction func changeType(_ sender: CustomizeSegmentedControl) {
        if sender.selectedValue==0{
            self.if_big=true
        }
        else{
            self.if_big=false
        }
    }
    
    @IBAction func GoToActivtyUpload(_ sender: Any) {
        if(UserInfo.ifLogin){
            let viewChange=self.storyboard?.instantiateViewController(withIdentifier: "activityUpload");
            self.show(viewChange!, sender: self)
            //self.present(viewChange!, animated:true, completion:nil)
        }
        else{
            let viewChange=self.storyboard?.instantiateViewController(withIdentifier: "login");
            self.show(viewChange!, sender: self)
        }
    }
    
    var activities = [Activity]();
    var selectedActivities = [Activity]();
    let navNames=["玩乐","商务","生活","校园"]
    var validActivities=[Activity]();
    
    override func viewWillAppear(_ animated: Bool) {
        guard let url=URL(string: "http://jhapp.com.au/displayAllActivity.php") else{return}
        var request=URLRequest(url: url)
        request.httpMethod="POST"
        let session=URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let data=data{
                do {
                    self.activities=try JSONDecoder().decode([Activity].self, from: data)
                    //print( self.activities.count)
                } catch{
                    print(error);
                }
                self.validActivities.removeAll();
                for activity in self.activities{
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = .short
                    dateFormatter.dateFormat="yyyy-MM-dd"
                    let dateObj = dateFormatter.date(from: activity.times)
                    let now=Date();
                    if(dateObj!>now){
                        self.validActivities.append(activity)
                    }
                }
                DispatchQueue.main.async {
                    self.selectedActivities=self.validActivities
                    self.activityView.reloadData();
                }
            }
            
        }.resume();
    }
    
    override func viewDidLoad() {
        //bigActivityView.dataSource=self;
       // bigActivityView.delegate=self;
        activityView.dataSource=self;
        activityView.delegate=self;
        activityNavView.delegate=self;
        activityNavView.dataSource=self;
        
        
       /* guard let url=URL(string: "http://jhapp.com.au/displayAllActivity.php") else{return}
        var request=URLRequest(url: url)
        request.httpMethod="POST"
        let session=URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let data=data{
                do {
                    self.activities=try JSONDecoder().decode([Activity].self, from: data)
                    //print( self.activities.count)
                } catch{
                    print(error);
                }
                for activity in self.activities{
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = .short
                    dateFormatter.dateFormat="yyyy-MM-dd"
                    let dateObj = dateFormatter.date(from: activity.times)
                    let now=Date();
                    if(dateObj!>now){
                        self.validActivities.append(activity)
                    }
                }
                DispatchQueue.main.async {
                    self.selectedActivities=self.validActivities
                    self.activityView.reloadData();
                }
            }
            
        }.resume();*/
        super.viewDidLoad()

        /*let httpBig=HttpRequest();
        httpBig.POST(url: "http://jianghu.000webhostapp.com/displayBigActivitiesPage.php", parameter: "")
        repeat {
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
        } while !httpBig.done
        do{
            self.bigActivities=try JSONDecoder().decode([BigActivity].self, from: httpBig.result)
        }catch{
            print(error);
        }*/
        
    }
    
}
