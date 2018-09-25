//
//  CommentController.swift
//  Jianghu
//
//  Created by Jiameng Cen on 26/7/18.
//  Copyright © 2018 InternationalTradeMaster. All rights reserved.
//

import UIKit

class CommentController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate {
    @IBOutlet weak var commentPost: UITextView!
    @IBOutlet weak var commentpost: UIButton!
    var hobby:HobbyArticle?
    //var comments = [Comment]();
    //var commentForPost = [Comment]();
    @IBOutlet weak var commentTableView: UITableView!
    @IBAction func sendComment(_ sender: Any) {
        if(commentPost.text != ""){
            let data=Comment(content: commentPost.text!, id: 0, user_id: hobby!.user_id, hobby_id: String(hobby!.id) , target_user: hobby!.user_id, user_name: (UserInfo.myInfo?.name)!, target_user_name: "", created_at:"") //之前是user_name:""
            let encoder=JSONEncoder();
            encoder.outputFormatting = .prettyPrinted
            let json=try? encoder.encode(data)
            print(String(data: json!, encoding: .utf8)!)
            guard let url=URL(string: "https://app.meljianghu.com/api/comment/post") else{return}
            let headers = [ "Content-Type": "application/json",
                            "Accept": "application/json",
                            "Authorization": "Bearer"+" " + UserInfo.token ]
            var request=URLRequest(url: url)
            request.httpMethod="POST"
            let para=String(data: json!, encoding: .utf8)
            request.httpBody = para!.data(using: String.Encoding.utf8);
            request.allHTTPHeaderFields = headers;
            let session=URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if let data=data{
                    do {
                       // let printString=String(data: data, encoding: String.Encoding.utf8)
                        //print(printString)
                        let reply = try JSONDecoder().decode(Reply.self, from: data)
                        if(reply.message=="success"){
                            DispatchQueue.main.async {
                                let viewChange=self.storyboard?.instantiateViewController(withIdentifier: "tab");
                                self.present(viewChange!, animated:true, completion:nil)
                            }
                        }
                        
                    } catch{
                        print(error);
                    }
                }
            }.resume();
        }
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "发表评论..."
            textView.textColor = UIColor.lightGray
        }
    }
    
    override func viewDidLoad() {
        commentPost.text = "发表评论..."
        commentPost.textColor = UIColor.lightGray
        commentPost.delegate=self
        commentTableView.dataSource = self;
        commentTableView.delegate=self;
        commentPost.layer.cornerRadius=commentPost.frame.height/10
        commentpost.layer.cornerRadius=commentpost.frame.height/10
        super.viewDidLoad()
        commentTableView.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(CommentController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CommentController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (hobby?.comments.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let commentCell = commentTableView.dequeueReusableCell(withIdentifier: "commentCell") as! CommentTableViewCell
       // comments = hobbyArticles[indexPath.row].comments
         commentCell.userName.text = hobby!.comments[indexPath.row].user_name;
        //commentCell.userImg. = comments[indexPath.row].target_user;
        commentCell.comment.text = hobby!.comments[indexPath.row].content;
        let timeString=hobby!.comments[indexPath.row].created_at
        let dateFormatter=DateFormatter()
        dateFormatter.dateFormat="yyyy-MM-dd HH:mm:ss"
        let dateObj = dateFormatter.date(from: timeString)
        dateFormatter.dateFormat="dd/MM/yy"
        let displayedTime=dateFormatter.string(from: dateObj!)
        commentCell.time.text = displayedTime
        commentCell.userImg.layer.cornerRadius=commentCell.userImg.frame.height/2
        commentCell.userImg.layer.masksToBounds=true
        return commentCell;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //commentTableView.isHidden = true
        //loadAction(activity_id: "0",type: "1")
        //loadCommentByUserID(cate_id: "1")
    }
    
    @IBOutlet weak var buttonPosition: NSLayoutConstraint!
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            buttonPosition.constant=keyboardSize.height*(-1) + 49;
        }
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            buttonPosition.constant=0;
        }
    }
    
    //some question???
    /*func loadCommentByUserID(cate_id:String){
        guard let url=URL(string: "http://app.meljianghu.com/api/hobby/get_by_cate/"+cate_id) else{return}
        let headers = [ "Content-Type": "application/json",
                        "Accept": "application/json"]
        var request=URLRequest(url: url)
        request.httpMethod="GET"
        let session=URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let data=data{
                do {
                    let printString=String(data: data, encoding: String.Encoding.utf8)
                    self.hobbyArticles=try JSONDecoder().decode([HobbyArticle].self, from: data)
                } catch{
                    print(error);
                }
                
            }
            DispatchQueue.main.async {
                //self.loading.stopAnimating()
                //self.loading.isHidden=true
                self.commentTableView.isHidden=false
                self.commentTableView.reloadData();
            }
            }.resume();
    } */
   
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


