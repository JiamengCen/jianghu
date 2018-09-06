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
    
    @IBOutlet weak var subActivityNav: UICollectionView!
    @IBOutlet var loading: UIActivityIndicatorView!
    @IBOutlet var segmentedView: CustomizeSegmentedControl!
    @IBOutlet weak var activityNavView: UICollectionView!
    @IBOutlet weak var activityView: UITableView!
    var if_big=false;
    var activities = [Activity]();
    //var collections:[Collection]=Array<Collection>();
    var cates:[Cate]=Array<Cate>();
    var activity_type="1";
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if(collectionView==activityNavView){
            return Globals.collections.count
        }
        else{
            return cates.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView == activityNavView){
            let cell = activityNavView.dequeueReusableCell(withReuseIdentifier: "navCell", for: indexPath) as! activityNavCell
            cell.name.text=Globals.collections[indexPath.row].name
            return cell;
        }
        else{
            let cell = subActivityNav.dequeueReusableCell(withReuseIdentifier: "ActivityDetailCell", for: indexPath) as! ActivityDetailCell
            cell.name.text=cates[indexPath.row].name
            return cell;
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(collectionView==activityNavView){
            cates=Globals.getCateByCollectionID(collection_id: String( Globals.collections[indexPath.row].id))
            subActivityNav.reloadData()
            let cell=collectionView.cellForItem(at: indexPath) as!activityNavCell
            for index in collectionView.indexPathsForVisibleItems{
                let allCellItem=collectionView.cellForItem(at: index) as!activityNavCell
                allCellItem.name.textColor=UIColor.black
                if((allCellItem.layer.sublayers?.count)!>1){
                    allCellItem.layer.sublayers![1].removeFromSuperlayer()
                }
            }
            //let border = CALayer()
            //let borderWidth = CGFloat(2.0)
            //border.borderColor = UIColor.red.cgColor
            //border.frame = CGRect(x: cell.frame.size.width*0.3, y: cell.frame.size.height - borderWidth, width:  cell.frame.size.width*0.45, height: cell.frame.size.height)
            //border.borderWidth = borderWidth
            //cell.layer.addSublayer(border)
            cell.name.textColor=UIColor.red
        }
        else{
            loadActivityByCateID(activity_id: String(cates[indexPath.row].id), type: activity_type)
            activityView.reloadData();
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return activities.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let activityCell = activityView.dequeueReusableCell(withIdentifier: "activity") as! ActivityCell
        activityCell.title.text = activities[indexPath.row].title;
        activityCell.time.text = activities[indexPath.row].start_time+" - "+activities[indexPath.row].end_time;
        activityCell.location.text = activities[indexPath.row].address;
        activityCell.img.contentMode = .scaleAspectFill
        activityCell.headImg.layer.cornerRadius=activityCell.headImg.frame.height/2;
        let topLink="https://app.meljianghu.com/storage/"+activities[indexPath.row].img_url_top
        activityCell.tagLable.text = activities[indexPath.row].cate_name;
        activityCell.img.downloadedFrom(url: topLink)
        //activityCell.img.sd_setImage(with: URL(string: topLink), placeholderImage: UIImage(named: ""))
        return activityCell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showActivityDetail", sender: self)
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
            destination.activity=activities[(activityView.indexPathForSelectedRow?.row)!]
        }
    }
    
    
    @IBAction func changeType(_ sender: CustomizeSegmentedControl) {
        if(sender.selectedValue==0){
            activity_type="1"
        }
        else{
            activity_type="2"
        }
    }
    
    @IBAction func GoToActivtyUpload(_ sender: Any) {
        if (UserInfo.token != "") {
            performSegue(withIdentifier: "uploadActivity", sender: self)
            
            //self.present(viewChange!, animated:true, completion:nil)
        }
        else{
            let viewChange=self.storyboard?.instantiateViewController(withIdentifier: "login");
            self.show(viewChange!, sender: self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loading.isHidden = false
        loading.startAnimating()
        
        activityView.isHidden = true
        //loadAction(activity_id: "0",type: "1")
        cates=Globals.getCateByCollectionID(collection_id: "1");
        loadActivityByCateID(activity_id: "1", type: activity_type)
        
        for index in self.activityNavView.indexPathsForVisibleItems{
            let allCellItem=self.activityNavView.cellForItem(at: index) as!activityNavCell
            allCellItem.name.textColor=UIColor.black
            if((allCellItem.layer.sublayers?.count)!>1){
                allCellItem.layer.sublayers![1].removeFromSuperlayer()
            }
        }
       // loadActivities(cate_id: "1");
        //loadHobbies(cate_id:"1");
        
        /*guard let url = URL(string: "http://app.meljianghu.com/api/activity/get_by_type/1") else
        {return}
        var request=URLRequest(url: url)
        request.httpMethod="POST"
        let session=URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let data=data{
                do {
                    self.activities=try JSONDecoder().decode([Activity].self, from: data)
                } catch{
                    print(error);
                }
                self.validActivities.removeAll();
                for activity in self.activities{
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = .short
                    dateFormatter.dateFormat="yyyy-MM-dd"
                    let dateObj = dateFormatter.date(from: activity.start_time)
                    let now=Date();
                    if(dateObj!>now){
                        self.validActivities.append(activity)
                    }
                }
                DispatchQueue.main.async {
                    self.selectedActivities=self.validActivities
                    self.loading.isHidden=true
                    self.loading.stopAnimating()
                    self.activityView.isHidden=false
                    self.activityView.reloadData();
                }
            }
            
        }.resume();
    */
        segmentedView.initialization();
    }
   /* func loadAction(activity_id: String,type: String){
        guard let url=URL(string: "http://app.meljianghu.com/api/activity/get_by_cate/"+activity_id+"/"+type) else{return}
        let headers = [ "Content-Type": "application/json",
                        "Accept": "application/json"]
        var request=URLRequest(url: url)
        request.httpMethod="GET"
        let session=URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let data=data{
                do {
                    let printString=String(data: data, encoding: String.Encoding.utf8)
                    self.activityTopTitle=try JSONDecoder().decode([ActivityTopTitle].self, from: data)
                    var buttonString = ""
                    for collection in self.collections{
                        buttonString=buttonString + collection.name + ",";
                    }
                    DispatchQueue.main.async {
                        //self.loading.stopAnimating()
                        //self.loading.isHidden=true
                        //self.hobbyContent.isHidden=false
                        //self.hobbyContent.reloadData();
                    }
                    //self.hobbyArticles=try JSONDecoder().decode([HobbyArticle].self, from: data)
                } catch{
                    print(error);
                }
                
            }
            
            }.resume();
    }
 */
    
    
    func loadActivityByCateID(activity_id: String,type: String){
        guard let url=URL(string: "https://app.meljianghu.com/api/activity/get_by_cate/"+activity_id+"/"+type) else{return}
        var request=URLRequest(url: url)
        request.httpMethod="GET"
        let session=URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let data=data{
                do {
                    self.activities=try JSONDecoder().decode([Activity].self, from: data)
                    DispatchQueue.main.async {
                        self.loading.stopAnimating()
                        self.loading.isHidden=true
                        self.activityView.reloadData()
                        self.activityView.isHidden=false
                    }
                } catch{
                    print(error);
                }
            }
            
            }.resume();
    }
    
    /*func loadActivities(cate_id:String){
        guard let url=URL(string: "http://app.meljianghu.com/api/activity/get_by_type/1"+cate_id) else{return}
        var request=URLRequest(url: url)
        request.httpMethod="GET"
        let session=URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let data=data{
                do {
                    let printString=String(data: data, encoding: String.Encoding.utf8)
                    print("zzzzzzzzzz")
                    print(printString)
                    self.activities=try JSONDecoder().decode([Activity].self, from: data)
                    
                } catch{
                    print(error);
                }
                
            }
            DispatchQueue.main.async {
                self.loading.stopAnimating()
                self.loading.isHidden=true
                self.activityView.isHidden=false
                self.activityView.reloadData();
            }
            }.resume();
    }
    */
    override func viewDidLoad() {
        activityView.dataSource=self;
        activityView.delegate=self;
        activityNavView.delegate=self;
        activityNavView.dataSource=self;
        subActivityNav.delegate=self
        subActivityNav.dataSource=self
        super.viewDidLoad()

    }
    
}
