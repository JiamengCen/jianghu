//
//  TopicController.swift
//  Jianghu
//
//  Created by WANG, Yanqi on 2018/5/4.
//  Copyright © 2018年 InternationalTradeMaster. All rights reserved.
//

import UIKit

class TopicController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var topicCateView: UICollectionView!
    @IBOutlet weak var topicCollectView: UICollectionView!
    @IBOutlet weak var topicTableView: UITableView!
    var activities = [Activity]()
    var cates:[Cate]=Array<Cate>();
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=topicTableView.dequeueReusableCell(withIdentifier: "topicCell") as! TopicCell
        cell.titleName.text = activities[indexPath.row].title;
        cell.content.text = activities[indexPath.row].content
        cell.tag1.text = "#" + activities[indexPath.row].collection_name
        cell.tag2.text = "#" +  activities[indexPath.row].cate_name
        let Link="https://app.meljianghu.com/storage/"+activities[indexPath.row].img_url_top
        cell.img.downloadedFrom(url: Link)
        let timeString=activities[indexPath.row].created_at
        let dateFormatter=DateFormatter()
        dateFormatter.dateFormat="yyyy-MM-dd HH:mm:ss"
        let dateObj = dateFormatter.date(from: timeString)
        dateFormatter.dateFormat="dd/MM/yy"
        let displayedTime=dateFormatter.string(from: dateObj!)
        cell.time.text = displayedTime
        //cell.time.text = activities[indexPath.row].created_at
        cell.img.contentMode = .scaleAspectFill  //maybe have problem
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier:"topicDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination=segue.destination as? ZhuantiDetailViewController{
        destination.activity =  activities[(topicTableView.indexPathForSelectedRow?.row)!]
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView==self.topicCollectView{
            return Globals.collections.count
        }
        else{
            return cates.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (collectionView == topicCollectView){
            let cell = topicCollectView.dequeueReusableCell(withReuseIdentifier: "topicCollectionCell", for: indexPath) as! TopicCollectionViewCell
            cell.topicCollectionName.text=Globals.collections[indexPath.row].name
            return cell;
        }
        else{
            let cell = topicCateView.dequeueReusableCell(withReuseIdentifier: "giftCateCell", for: indexPath) as! TopicCateViewCell
            cell.topicCateName.text=cates[indexPath.row].name
            return cell;
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (collectionView == topicCollectView){
            cates = Globals.getCateByCollectionID(collection_id: String(Globals.collections[indexPath.row].id))
            topicCateView.reloadData()
            let cell=collectionView.cellForItem(at: indexPath) as!TopicCollectionViewCell
            for index in collectionView.indexPathsForVisibleItems{
                let allCellItem=collectionView.cellForItem(at: index) as!TopicCollectionViewCell
                allCellItem.topicCollectionName.textColor=UIColor.black
                if((allCellItem.layer.sublayers?.count)!>1){
                    allCellItem.layer.sublayers![1].removeFromSuperlayer()
                }
            }
            let border = CALayer()
            let borderWidth = CGFloat(2.0)
            border.borderColor = UIColor.red.cgColor
            border.frame = CGRect(x: cell.frame.size.width*0.3, y: cell.frame.size.height - borderWidth, width:  cell.frame.size.width*0.45, height: cell.frame.size.height)
            border.borderWidth = borderWidth
            cell.layer.addSublayer(border)
            cell.topicCollectionName.textColor=UIColor.red
        }
        else{
            loadTopic(cate_id: String(cates[indexPath.row].id), type: "4")
            topicTableView.reloadData();
            let cell=collectionView.cellForItem(at: indexPath) as!TopicCateViewCell
            for index in collectionView.indexPathsForVisibleItems{
                let allCellItem=collectionView.cellForItem(at: index) as!TopicCateViewCell
                allCellItem.topicCateName.textColor=UIColor.black
                if((allCellItem.layer.sublayers?.count)!>1){
                    allCellItem.layer.sublayers![1].removeFromSuperlayer()
                }
            }
            let border = CALayer()
            let borderWidth = CGFloat(2.0)
            border.borderColor = UIColor.red.cgColor
            border.frame = CGRect(x: cell.frame.size.width*0.3, y: cell.frame.size.height - borderWidth, width:  cell.frame.size.width*0.45, height: cell.frame.size.height)
            border.borderWidth = borderWidth
            cell.layer.addSublayer(border)
            cell.topicCateName.textColor=UIColor.red
        }
    }
    
    func loadTopic(cate_id:String, type:String){
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
                    print("ddddddddddd")
                    print(printString)
                   
                    self.activities=try JSONDecoder().decode([Activity].self, from: data)
                } catch{
                    print(error);
                }
                
            }
            DispatchQueue.main.async {
                //self.loading.stopAnimating()
                //self.loading.isHidden=true
                self.topicTableView.isHidden=false
                self.topicTableView.reloadData();
            }
            }.resume();
    }
    //var hobbyArticles=[HobbyArticle]()
    override func viewDidLoad() {
       topicTableView.delegate=self;
        topicTableView.dataSource=self;
       topicCollectView.delegate=self;
        topicCollectView.dataSource=self;
       topicCateView.delegate=self
       topicCateView.dataSource=self
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //loading.isHidden = false
        //loading.startAnimating()
        topicTableView.separatorStyle = .none
        topicTableView.isHidden = true
        //loadAction(activity_id: "0",type: "1")
       // loadCate(collection_id: "1")
        cates=Globals.getCateByCollectionID(collection_id: "1")
        topicCateView.reloadData()
        loadTopic(cate_id: "1",type:"4")
        
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
