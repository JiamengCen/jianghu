//
//  ServiceViewController.swift
//  Jianghu
//
//  Created by Jiameng Cen on 21/7/18.
//  Copyright © 2018 InternationalTradeMaster. All rights reserved.
//

import UIKit

class ServiceViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var loading: UIActivityIndicatorView!
    var serviceActivities = [Activity]();
    var cates:[Cate]=Array<Cate>();
    @IBOutlet weak var serviceCollectionView: UICollectionView!
    @IBOutlet weak var serviceTableView: UITableView!
    
    @IBOutlet weak var serviceCateView: UICollectionView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serviceActivities.count
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let serviceCells = serviceTableView.dequeueReusableCell(withIdentifier: "serviceTableView") as! ServiceTableViewCell
        serviceCells.time.text = serviceActivities[indexPath.row].start_time+" - " + serviceActivities[indexPath.row].end_time;
        serviceCells.serviceTitle.text=serviceActivities [indexPath.row].title;
        //serviceCells.serviceImg.contentMode = .scaleAspectFill
        let topLink="https://app.meljianghu.com/storage/"+serviceActivities[indexPath.row].img_url_top
        serviceCells.serviceImg.downloadedFrom(url: topLink)
        serviceCells.serviceImg.contentMode = .scaleAspectFit
        return serviceCells
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    /* if tableView==self.activityView{
     performSegue(withIdentifier: "showActivity", sender: self)
     }
     else{
     performSegue(withIdentifier: "showBigActivity", sender: self)
     }*/
        performSegue(withIdentifier: "showServiceDetail", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    
        if let destination=segue.destination as? ServiceDetailViewController{
         destination.activity = serviceActivities [(serviceTableView.indexPathForSelectedRow?.row)!]
    }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if(collectionView == serviceCollectionView){
            
            return Globals.collections.count
        }
        else{
            print("dskjfhakdjsfhakdjsfhdaksjf")
            print(cates.count)
            return cates.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView == serviceCollectionView){
            let ServicecateCell=serviceCollectionView.dequeueReusableCell(withReuseIdentifier: "serviceCollectionCell", for: indexPath) as! activityNavCell
            ServicecateCell.name.text=Globals.collections[indexPath.row].name
            return ServicecateCell
        }
        else{
            let collectionCell=serviceCateView.dequeueReusableCell(withReuseIdentifier: "serviceCateCell", for: indexPath) as! activityNavCell
            collectionCell.name.text=cates[indexPath.row].name
            return collectionCell
        }
   
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if(collectionView == serviceCollectionView){
            cates = Globals.getCateByCollectionID(collection_id: String( Globals.collections[indexPath.row].id))
            serviceCateView.reloadData()
        }
        else{
            loadService(cate_id: String(cates[indexPath.row].id), type: "3")
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        //loading.isHidden = false
        //loading.startAnimating()
    
        serviceTableView.isHidden = true
        cates=Globals.getCateByCollectionID(collection_id: "1");
        serviceCateView.reloadData()
        loadService(cate_id: "1",type:"3")
        
}
    
    
    
    
    
    func loadService(cate_id: String,type: String){
      guard let url=URL(string: "https://app.meljianghu.com/api/activity/get_by_cate/"+cate_id+"/"+type) else{return}
        let headers = [ "Content-Type": "application/json",
                        "Accept": "application/json"]
        var request=URLRequest(url: url)
        request.httpMethod="GET"
        let session=URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let data=data{
                do {
                    let printString=String(data: data, encoding: String.Encoding.utf8)
                    print(printString)
                    self.serviceActivities=try JSONDecoder().decode([Activity].self, from: data)
                    //self.collections=try JSONDecoder().decode([Collection].self, from: data)
                    //var buttonString = ""
                    /* for collection in self.collections{
                     buttonString=buttonString + collection.name + ",";
                     }*/
                    DispatchQueue.main.async {
                        //self.segmentedView.ButtonTitleString=buttonString
                        //self.segmentedView.updateView()
                        self.serviceTableView.isHidden=false
                        self.serviceTableView.reloadData();
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
    override func viewDidLoad() {
        serviceCollectionView.delegate=self;
        serviceCollectionView.dataSource=self;
        serviceTableView.delegate=self;
        serviceTableView.dataSource=self;
        serviceCateView.delegate=self
        serviceCateView.dataSource=self
        super.viewDidLoad()
        //serviceTableView.estimatedRowHeight=500
        //serviceTableView.rowHeight = UITableViewAutomaticDimension
        

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

