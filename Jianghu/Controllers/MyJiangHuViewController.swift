//
//  MyJiangHuViewController.swift
//  Jianghu
//
//  Created by Jiameng Cen on 16/7/18.
//  Copyright © 2018 InternationalTradeMaster. All rights reserved.
//

import UIKit

class MyJiangHuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var hobbyArticles=[HobbyArticle]();
    var selectedHobby:HobbyArticle?
    @IBOutlet weak var myHobbyContent: UITableView!
    @IBOutlet weak var backImgToTop: NSLayoutConstraint!
    @IBOutlet weak var userNametoTop: NSLayoutConstraint!
    @IBOutlet weak var backImgHeight: NSLayoutConstraint!
    @IBOutlet weak var userHeadHeight: NSLayoutConstraint!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userHeadToTop: NSLayoutConstraint!
    @IBOutlet var wholeContent: UIView!
    @IBOutlet weak var userHead: UIImageView!
    var ifHide=false;
    var initialBackImgTop:CGFloat?;
    override func viewDidLoad() {
    userName.text=UserInfo.myInfo?.name
        myHobbyContent.dataSource = self;
        myHobbyContent.delegate = self;
        initialBackImgTop=backImgToTop.constant
        super.viewDidLoad()
        circularImage(userHead: self.userHead)
        myHobbyContent.estimatedRowHeight=500
        myHobbyContent.rowHeight = UITableViewAutomaticDimension
        loadHobbies()
        
        //self.userHead.layer.cornerRadius = self.userHead.frame.height/2
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func circularImage(userHead: UIImageView?){
        //userHead!.layer.frame = CGRectInset(userHead!.layer.frame, 0, 0)
        userHead!.layer.cornerRadius = userHead!.frame.height/2
        userHead!.layer.masksToBounds = false
        userHead!.clipsToBounds = true
        userHead!.layer.borderWidth = 0.5
        userHead!.contentMode = UIViewContentMode.scaleAspectFill
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return hobbyArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = myHobbyContent.dequeueReusableCell(withIdentifier: "hobbyTableCell") as! HobbyTableViewCell
            cell.selectionStyle = .none
            
            cell.imgs.append(cell.img1)
            cell.imgs.append(cell.img2)
            cell.imgs.append(cell.img3)
            cell.imgs.append(cell.img4)
            cell.imgs.append(cell.img5)
            cell.imgs.append(cell.img6)
            for i in cell.imgs
            {
                let g = UITapGestureRecognizer(target: self, action: #selector(showBigPic))
                i.addGestureRecognizer(g)
                // currentSelectedIndexPath=indexPath
                i.isUserInteractionEnabled = true
            }
            
            //print( indexPath.row);
            //print(hobbyArticles.count)
            cell.user.text = hobbyArticles[indexPath.row].user_name
            let timeString=hobbyArticles[indexPath.row].created_at
            let dateFormatter=DateFormatter()
            dateFormatter.dateFormat="yyyy-MM-dd HH:mm:ss"
            let dateObj = dateFormatter.date(from: timeString)
            dateFormatter.dateFormat="dd/MM/yy"
            let displayedTime=dateFormatter.string(from: dateObj!)
            cell.time.text = displayedTime
            cell.content.text=hobbyArticles[indexPath.row].content
            cell.cate.text=hobbyArticles[indexPath.row].cate_name
            cell.cate.layer.cornerRadius=cell.cate.frame.height/10
            cell.head.layer.cornerRadius=cell.head.frame.height/2
            cell.head.layer.masksToBounds=true
            cell.commentButton.addTarget(self, action: #selector(goToComment), for: .touchUpInside)
            
            //cell.commentButton.addta
            let img_array = hobbyArticles[indexPath.row].image_url.components(separatedBy: "|");
            cell.imgCount=img_array.count
            let totalImageView=6;
            if(img_array.count<4){
                cell.imgStack2.isHidden=true;
                cell.totalStackHeight.constant=90
                
            }
            else{
                cell.imgStack2.isHidden=false;
                cell.totalStackHeight.constant=190
            }
            var  i=0
            //     print("zzzzzzzzzz")
            //     print(img_array.count)
            while(i<totalImageView){
                if(i<img_array.count){
                    print(img_array[i])
                    //imgs[i].downloadedFrom(url: "http://app.meljianghu.com/storage/"+img_array[i])
                    cell.imgs[i].sd_setImage(with: URL(string: "https://app.meljianghu.com/storage/"+img_array[i]), placeholderImage: UIImage(named: ""))
                    cell.imgs[i].contentMode = .scaleAspectFill
                }
                else{
                    cell.imgs[i].image=nil
                    
                }
                i=i+1
            }
            
            return cell
    }
    

    
    @objc func showBigPic(_ recognizer:UITapGestureRecognizer){
        //图片索引
        let index = recognizer.view!.tag
        let point=recognizer.location(in: self.myHobbyContent)
        let indexPath = self.myHobbyContent.indexPathForRow(at: point)
        /*let position:CGPoint = recognizer.convert(CGPoint.zero, to:self.hobbyContent)
         let indexPath = self.tableView.indexPathForRow(at: position)*/
        //进入图片全屏展示
        let cell = myHobbyContent.cellForRow(at: indexPath!) as! HobbyTableViewCell
        let previewVC = ImagePreviewVC(images:cell.imgs, index: index, img_count: cell.imgCount)
        self.navigationController?.pushViewController(previewVC, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showMyJianghuComment"){
            if let destination=segue.destination as? CommentController{
                destination.hobby=selectedHobby
            }
        }
    }
    
    @objc func goToComment(sender: UIButton) {
        let buttonPostion = sender.convert(sender.bounds.origin, to: myHobbyContent)
        
        if let indexPath = myHobbyContent.indexPathForRow(at: buttonPostion) {
            selectedHobby=hobbyArticles[indexPath.row]
        }
        if(UserInfo.token != ""){
            performSegue(withIdentifier: "showMyJianghuComment", sender: sender)
        }
        else{
            let viewChange=self.storyboard?.instantiateViewController(withIdentifier: "login");
            self.show(viewChange!, sender: self)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y > 50){
            if(self.ifHide==false){
                self.backImgToTop.constant = (self.backImgHeight.constant+self.userHeadHeight.constant/2)*(-1)
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.layoutIfNeeded()
                })
            }
            self.ifHide=true
        }
        if(scrollView.contentOffset.y < 50){
            if(self.ifHide==true){
                self.backImgToTop.constant = self.initialBackImgTop!
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.layoutIfNeeded()
                })
                self.ifHide=false
            }
        }
    }
    
    func loadHobbies(){
        guard let url=URL(string: "https://app.meljianghu.com/api/hobby/my") else{return}
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
                     self.hobbyArticles=try JSONDecoder().decode([HobbyArticle].self, from: data)
                } catch{
                    print(error);
                }
            }
            DispatchQueue.main.async {
                self.myHobbyContent.isHidden=false
                self.myHobbyContent.reloadData();
            }
        }.resume();
    }
    
    
}
