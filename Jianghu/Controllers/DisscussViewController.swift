//
//  DisscussViewController.swift
//  Jianghu
//
//  Created by Jiameng Cen on 19/7/18.
//  Copyright © 2018 InternationalTradeMaster. All rights reserved.
//

import UIKit

class DisscussViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var contactList: UITableView!
    @IBOutlet weak var group: UITableView!
    @IBOutlet weak var switchbar: CustomizeSegmentedControl!
    let navNames=["玩乐","商务","生活","校园"]
    var if_big=false;
    var discusses = [Discuss]();
    var selectedDiscuss = [Discuss]();
    var validDiscuss=[Discuss]();
    var userInfoList = Array<UserInformation>()
    
    @IBAction func changeType(_ sender: CustomizeSegmentedControl) {
        if(sender.selectedValue==0){
            self.group.isHidden=true
        }
        else{
            self.group.isHidden=false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        switchbar.initialization()
        if(UserInfo.token != ""){
            return
        }
        else{
            let viewChange=self.storyboard?.instantiateViewController(withIdentifier: "login");
            self.show(viewChange!, sender: self)
        }
    }
        
    override func viewDidLoad() {
        loadContactList()
        group.dataSource=self
        group.delegate=self
        contactList.dataSource = self;
        contactList.delegate=self;
        super.viewDidLoad()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   /* func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return navNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = typecollection.dequeueReusableCell(withReuseIdentifier: "hobbyNames", for: indexPath) as! HobbyNameCell
        cell.hobbyNameLable.text=navNames[indexPath.row]
        return cell;
    }
 */
    
    /*func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedActivities.removeAll();
        for activity in validActivities{
            if (activity.category==navNames[indexPath.row]){
                if(self.if_big == true){
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
        group.reloadData();
    }
    */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*if tableView==self.activityView{
         return activities.count;
         }
         else{
         return bigActivities.count;
         }*/
        //return selectedDiscuss.count;
        if tableView==self.group{
            return 1
        }
        else{
            return userInfoList.count;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       /* let discussCell = discussView.dequeueReusableCell(withIdentifier: "discuss") as! DiscussCell
        discussCell.title.text = selectedDiscuss[indexPath.row].title;
        discussCell.timeLabel.text = selectedDiscuss[indexPath.row].times
        discussCell.ImageHead.layer.cornerRadius=discussCell.ImageHead.frame.height/2;
        // activityCell.hotButton.layer.cornerRadius=5;
        return discussCell; */
        if(tableView==contactList){
            let contactlistCell = contactList.dequeueReusableCell(withIdentifier: "contactListCell") as! ContactListCell
                contactlistCell.userName.text = userInfoList[indexPath.row].name
                let timeString=userInfoList[indexPath.row].created_at
                let dateFormatter=DateFormatter()
                dateFormatter.dateFormat="yyyy-MM-dd HH:mm:ss"
                let dateObj = dateFormatter.date(from: timeString)
                dateFormatter.dateFormat="dd/MM/yy"
                let displayedTime=dateFormatter.string(from: dateObj!)
                contactlistCell.time.text = displayedTime
                //contactlistCell.time.text = userInfoList[indexPath.row].created_at
                contactlistCell.useImg!.layer.cornerRadius = contactlistCell.useImg!.frame.height/2
                contactlistCell.useImg.layer.masksToBounds=true
                let userId = userInfoList[indexPath.row].id
                let contactId = userInfoList[indexPath.row].chatkit_id
                ChatRoomData.init(user_one_id: String(userId), user_two_id: contactId )
                return contactlistCell;
        }
        else{
            let dicussGroupCell = group.dequeueReusableCell(withIdentifier: "discussGroup")as!
            GroupDiscussCell
            
            return dicussGroupCell;
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView==contactList{
              performSegue(withIdentifier: "showContactFromdiscuss", sender: self)
        }
        else{
            performSegue(withIdentifier: "showDiscussDetail", sender: self)
        }
      
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination=segue.destination as? ContactViewController{
            print(String( userInfoList[(contactList.indexPathForSelectedRow?.row)!].id))
            destination.another_user_id = String( userInfoList[(contactList.indexPathForSelectedRow?.row)!].id)
        }
    }
    
    func loadContactList(){
        guard let url=URL(string:"https://app.meljianghu.com/api/chat/get_chat") else{return}
        let headers = [ "Content-Type": "application/json",
                        "Accept": "application/json",
                        "Authorization": "Bearer"+" " + UserInfo.token ]
        var request=URLRequest(url: url)
        request.httpMethod="GET"
        request.allHTTPHeaderFields = headers;
        let session=URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let data=data{
                do {
                    let printString=String(data: data, encoding: String.Encoding.utf8)
                    print(printString)
                    self.userInfoList=try JSONDecoder().decode([UserInformation].self, from: data)
                    DispatchQueue.main.async {
                        /*   self.loading.stopAnimating()
                         self.loading.isHidden=true
                         self.hobbyContent.isHidden=false
                         self.hobbyContent.reloadData();
                         if(self.ifLoadFromDropDown){
                         let cell=self.nameView.cellForItem(at: self.dropDownIndexPath!) as!HobbyNameCell */
                        //}
                        self.contactList.reloadData()
                    }
                } catch{
                    print(error);
                }
            }
      
            }.resume();
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
