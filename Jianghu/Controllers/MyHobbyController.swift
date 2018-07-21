//
//  MyHobbyController.swift
//  Jianghu
//
//  Created by WANG, Yanqi on 2018/5/7.
//  Copyright © 2018年 InternationalTradeMaster. All rights reserved.
//

import UIKit

class MyHobbyController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var hobbyArticles=[HobbyArticle]();
    
    @IBOutlet weak var content: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hobbyArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var imgs=[UIImageView]();
        let cell = content.dequeueReusableCell(withIdentifier: "hobbyTableCell") as! HobbyTableViewCell
        imgs.append(cell.img1)
        imgs.append(cell.img2)
        imgs.append(cell.img3)
        imgs.append(cell.img4)
        imgs.append(cell.img5)
        imgs.append(cell.img6)
        cell.user.text = hobbyArticles[indexPath.row].user_name
        cell.content.text=hobbyArticles[indexPath.row].content
        cell.tag2.text=hobbyArticles[indexPath.row].tag2
        cell.tag2.layer.cornerRadius=cell.frame.height/10;
        let link="http://jhapp.com.au/"+hobbyArticles[indexPath.row].img
        let imgCount=Int(hobbyArticles[indexPath.row].img_num!);
        let totalImageView=6;
        if(imgCount!<4){
            cell.imgStack2.isHidden=true;
            cell.totalStackHeight.constant=90
            
        }
        else{
            cell.imgStack2.isHidden=false;
            cell.totalStackHeight.constant=190
        }
        var i=0;
        while(i<totalImageView){
            if(i<imgCount!){
                imgs[i].downloadedFrom(link: link+"_"+String(i))
                imgs[i].contentMode = .scaleAspectFill
            }
            else{
                imgs[i].image=nil
                
            }
            i=i+1
        }
        //cell.img.downloadedFrom(link:defualtLink+addLink)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier:"myHobbyShowDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination=segue.destination as? HobbyArticleController{
            destination.article=hobbyArticles[(content.indexPathForSelectedRow?.row)!]
        }
    }
    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            
            guard let url=URL(string: "http://jhapp.com.au/deleteHobby.php") else{return}
            var request=URLRequest(url: url)
            request.httpMethod="POST"
            let para="user="+UserInfo.id+"&article="+self.hobbyArticles[indexPath.row].id;
            request.httpBody=para.data(using: String.Encoding.utf8);
            let session=URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if let data=data{
                    guard let result = try? JSONSerialization.jsonObject(with: data, options:[]) as? [String:
                        Any] else{
                            print("Error: Couldn't decode data ")
                            return
                    }
                    DispatchQueue.main.async {
                        if result?["reply"] as! String=="SUCCESS"{
                            self.hobbyArticles.remove(at: indexPath.row)
                            tableView.deleteRows(at: [indexPath], with: .fade)
                        }
                    }
                }
                }.resume();
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        guard let url = URL(string:"http://jhapp.com.au/displayUserHobby.php"+"?id="+UserInfo.id) else {
            return
        }
        let session=URLSession.shared
        session.dataTask(with: url) { (data, response, error) in

            if let data=data{
                let printString=String(data: data, encoding: String.Encoding.utf8)
                do{
                    self.hobbyArticles=try JSONDecoder().decode([HobbyArticle].self, from: data)
                }catch{
                    print(error);
                }
                DispatchQueue.main.async {
                    self.content.reloadData();
                }
            }
        }.resume();
        
        content.delegate=self
        content.dataSource=self
        
        
        
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
