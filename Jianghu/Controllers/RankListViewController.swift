//
//  RankListViewController.swift
//  Jianghu
//
//  Created by Jiameng Cen on 19/7/18.
//  Copyright © 2018 InternationalTradeMaster. All rights reserved.
//

import UIKit

class RankListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var rankListTableView: UITableView!
    //var ranklist = [RankList]()
    var userList=Array<UserInformation>()
    override func viewDidLoad() {
        rankListTableView.dataSource=self;
        rankListTableView.delegate=self;
        loadRank()
        super.viewDidLoad()
        //circularImage(userHeadTop:self.userHeadTop)
        // Do any additional setup after loading the view.
        
    }
    
    func circularImage(userHeadTop: UIImageView?){
        //userHead!.layer.frame = CGRectInset(userHead!.layer.frame, 0, 0)
        userHeadTop!.layer.cornerRadius = userHeadTop!.frame.height/2
        userHeadTop!.layer.masksToBounds = false
        userHeadTop!.clipsToBounds = true
        userHeadTop!.layer.borderWidth = 0.5
        userHeadTop!.contentMode = UIViewContentMode.scaleAspectFill
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rankCell = rankListTableView.dequeueReusableCell(withIdentifier: "ranklist") as! RankListCell
        rankCell.nameTitle.text = userList[indexPath.row].name;
        rankCell.creditNum.text = userList[indexPath.row].points;
        rankCell.userHead.layer.cornerRadius=rankCell.userHead.frame.height/2
        rankCell.userHead.layer.masksToBounds=true
        rankCell.creditNum.isHidden=true
        //let cell = rankListTableView.cellForRow(at: indexPath) as! HobbyTableViewCell
        if(indexPath.row == 0){
            rankCell.medal.image=UIImage(named: "1")
            rankCell.medal.isHidden = false
        }
        else if (indexPath.row == 1){
            rankCell.medal.image=UIImage(named: "2")
            rankCell.medal.isHidden = false
        }
        else if (indexPath.row == 2){
            rankCell.medal.image=UIImage(named: "3")
            rankCell.medal.isHidden = false
        }
        else{
            rankCell.medal.isHidden = true
        }
        return rankCell;
    }
    
    func loadRank(){
        guard let url=URL(string: "https://app.meljianghu.com/api/user/rank") else{return}
        var request=URLRequest(url: url)
        request.httpMethod="GET"
        let session=URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let data=data{
                do {
                    let printString=String(data: data, encoding: String.Encoding.utf8)
                    print(printString)
                    self.userList=try JSONDecoder().decode([UserInformation].self, from: data)
                    DispatchQueue.main.async {
                        self.rankListTableView.isHidden=false
                        self.rankListTableView.reloadData();
                    }
                    
                } catch{
                    print(error);
                }
                
            }
            
            }.resume();
    }

}
