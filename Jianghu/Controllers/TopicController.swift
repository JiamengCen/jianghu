//
//  TopicController.swift
//  Jianghu
//
//  Created by WANG, Yanqi on 2018/5/4.
//  Copyright © 2018年 InternationalTradeMaster. All rights reserved.
//

import UIKit

class TopicController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hobbyArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=content.dequeueReusableCell(withIdentifier: "topicCell") as! TopicCell
        cell.user.text = hobbyArticles[indexPath.row].user_name
        cell.titleName.text = hobbyArticles[indexPath.row].title
        let link="http://jhapp.com.au/"+hobbyArticles[indexPath.row].img+"_0";
        cell.img.downloadedFrom(link:link)
        cell.img.contentMode = .scaleAspectFill
        cell.img.clipsToBounds=true
        cell.content.text=hobbyArticles[indexPath.row].content
        cell.tag1.text="#"+hobbyArticles[indexPath.row].tag1
        cell.tag2.text="#"+hobbyArticles[indexPath.row].tag2
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier:"showTopic", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination=segue.destination as? HobbyArticleController{
            destination.article=hobbyArticles[(content.indexPathForSelectedRow?.row)!]
        }
    }
    
    var hobbyArticles=[HobbyArticle]()
    @IBOutlet weak var content: UITableView!
    override func viewDidLoad() {
        content.delegate=self;
        content.dataSource=self;
        super.viewDidLoad()
        
        
        
        
        guard let url=URL(string: "http://jianghu.000webhostapp.com/displayTopics.php") else{return}
        var request=URLRequest(url: url)
        request.httpMethod="POST"
        let session=URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let data=data{
                do{
                    self.hobbyArticles=try JSONDecoder().decode([HobbyArticle].self, from: data)
                }catch{
                    print(error);
                }
                DispatchQueue.main.async {
                    self.content.reloadData()
                }
            }
        }.resume();
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
