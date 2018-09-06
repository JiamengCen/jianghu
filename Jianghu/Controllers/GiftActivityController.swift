//
//  GiftActivityController.swift
//  Jianghu
//
//  Created by Jiameng Cen on 16/7/18.
//  Copyright © 2018 InternationalTradeMaster. All rights reserved.
//

import UIKit

class GiftActivityController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var giftCollectView: UICollectionView!
    @IBOutlet weak var giftTableView: UITableView!
    var activities = [Activity]()
    @IBOutlet weak var giftCate: UICollectionView!
    var cates:[Cate]=Array<Cate>();
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return activities.count
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let giftArticleCell = giftTableView.dequeueReusableCell(withIdentifier: "gift") as! GiftCell
        giftArticleCell.title.text = activities[indexPath.row].title;
        giftArticleCell.location.text = activities[indexPath.row].address;
        giftArticleCell.time.text = activities[indexPath.row].created_at
        giftArticleCell.backgroImag.contentMode = .scaleAspectFill
        giftArticleCell.headImg.contentMode = .scaleAspectFill
        giftArticleCell.headImg.layer.cornerRadius=giftArticleCell.headImg.frame.height/2;
        let topLink="https://app.meljianghu.com/storage/"+activities[indexPath.row].img_url_top
        giftArticleCell.backgroImag.downloadedFrom(url: topLink)
        return  giftArticleCell;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView==self.giftCate{
            return self.cates.count
        }
        else{
            return Globals.collections.count
        }
}
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /* if tableView==self.activityView{
         performSegue(withIdentifier: "showActivity", sender: self)
         }
         else{
         performSegue(withIdentifier: "showBigActivity", sender: self)
         }*/
        performSegue(withIdentifier: "showGiftDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   
        if let destination=segue.destination as? GiftDetailController{
        destination.activity=activities[giftTableView.indexPathForSelectedRow!.row]
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (collectionView == giftCollectView){
            let cell = giftCollectView.dequeueReusableCell(withReuseIdentifier: "giftCollectionCell", for: indexPath) as! GiftCollectionCell
            cell.giftcollectName.text=Globals.collections[indexPath.row].name
            return cell;
        }
        else{
            let cell = giftCate.dequeueReusableCell(withReuseIdentifier: "giftCateCell", for: indexPath) as! GiftCateCell
            cell.giftCateName.text=cates[indexPath.row].name
            return cell;
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(collectionView == giftCollectView){
            print(indexPath.row)
            cates=Globals.getCateByCollectionID(collection_id: String(Globals.collections[indexPath.row].id))
            giftCate.reloadData()
            let cell=collectionView.cellForItem(at: indexPath) as!GiftCollectionCell
            for index in collectionView.indexPathsForVisibleItems{
                let allCellItem=collectionView.cellForItem(at: index) as!GiftCollectionCell
                allCellItem.giftcollectName.textColor=UIColor.black
                if((allCellItem.layer.sublayers?.count)!>1){
                    allCellItem.layer.sublayers![1].removeFromSuperlayer()
                }
            }
            
            let border = CALayer()
            let borderWidth = CGFloat(2.0)
            border.borderColor = UIColor.red.cgColor
            border.frame = CGRect(x: cell.frame.size.width*0.3, y: cell.frame.size.height - borderWidth, width:cell.frame.size.width*0.45, height: cell.frame.size.height)
            border.borderWidth = borderWidth
            cell.layer.addSublayer(border)
            print("xxxxxxxxxxxxxxxxxx")
            cell.giftcollectName.textColor=UIColor.red
        }
        else{
            loadGift(cate_id: String(cates[indexPath.row].id), type: "0")
            let cell=collectionView.cellForItem(at: indexPath) as!GiftCateCell
            for index in collectionView.indexPathsForVisibleItems{
                let allCellItem=collectionView.cellForItem(at: index) as!GiftCateCell
                allCellItem.giftCateName.textColor=UIColor.black
                if((allCellItem.layer.sublayers?.count)!>1){
                    allCellItem.layer.sublayers![1].removeFromSuperlayer()
                }
            }
            let border = CALayer()
            let borderWidth = CGFloat(2.0)
            border.borderColor = UIColor.red.cgColor
            border.frame = CGRect(x: cell.frame.size.width*0.3, y: cell.frame.size.height - borderWidth, width:cell.frame.size.width*0.45, height: cell.frame.size.height)
            border.borderWidth = borderWidth
            cell.layer.addSublayer(border)
            cell.giftCateName.textColor=UIColor.red
        }
        
    }
    
    
    func loadGift(cate_id:String, type:String){
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
                    self.activities=try JSONDecoder().decode([Activity].self, from: data)
                } catch{
                    print(error);
                }
                
            }
            DispatchQueue.main.async {
                self.giftTableView.isHidden=false
                self.giftTableView.reloadData();
            }
            }.resume();
    }
        
    override func viewDidLoad() {
        giftTableView.dataSource=self;
        giftTableView.delegate=self;
        giftCollectView.delegate=self;
        giftCollectView.dataSource=self;
        giftCate.delegate=self
        giftCate.dataSource=self
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        //loading.isHidden = false
        //loading.startAnimating()
        
        giftTableView.isHidden = true
        cates=Globals.getCateByCollectionID(collection_id: "1")
        
        loadGift(cate_id: "1",type:"0")

    

    }
}
