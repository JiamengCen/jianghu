//
//  TopicCommentController.swift
//  Jianghu
//
//  Created by Jiameng Cen on 6/8/18.
//  Copyright © 2018 InternationalTradeMaster. All rights reserved.
//

import UIKit

class TopicCommentController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate {
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (topicActivity?.comments.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let commentCell = topicComment.dequeueReusableCell(withIdentifier: "topicCommentCell") as! CommentTableViewCell
        commentCell.userName.text = topicActivity!.comments[indexPath.row].target_user_name;
        commentCell.comment.text = topicActivity!.comments[indexPath.row].content;
        let timeString=topicActivity!.comments[indexPath.row].created_at
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
    
    

    @IBAction func sendPost(_ sender: Any) {
        if(writeComment.text != ""){
            let data=ActivityComment(content: writeComment.text!, id: 0, user_id: topicActivity!.user_id, activity_id: String(topicActivity!.id) , target_user: topicActivity!.user_id, user_name: "", target_user_name: "", created_at:"")
            let encoder=JSONEncoder();
            encoder.outputFormatting = .prettyPrinted
            let json=try? encoder.encode(data)
            print(String(data: json!, encoding: .utf8)!)
            guard let url=URL(string: "https://app.meljianghu.com/api/comment/activity/post") else{return}
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
                                let viewChange=self.storyboard?.instantiateViewController(withIdentifier: "topicDetail");
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
    @IBOutlet weak var postComment: UIButton!
    @IBOutlet weak var writeComment: UITextView!
    @IBOutlet weak var topicComment: UITableView!
    @IBOutlet weak var buttonPosition: NSLayoutConstraint!
    var topicActivity:Activity?
    override func viewDidLoad() {
        topicComment.dataSource = self;
        topicComment.delegate=self;
        writeComment.text = "发表评论..."
        writeComment.textColor = UIColor.lightGray
        writeComment.delegate=self
        postComment.layer.cornerRadius=postComment.frame.height/10
        super.viewDidLoad()
        topicComment.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(TopicCommentController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(TopicCommentController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        

        // Do any additional setup after loading the view.
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            buttonPosition.constant=keyboardSize.height*(-1)+50;
        }
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            buttonPosition.constant=0;
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return (topicActivity?.comments.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let commentCell = topicComment.dequeueReusableCell(withIdentifier: " topicCommentCell") as! CommentTableViewCell
        commentCell.userName.text = topicActivity!.comments[indexPath.row].target_user_name;
        commentCell.comment.text = topicActivity!.comments[indexPath.row].content;
        let timeString=topicActivity!.comments[indexPath.row].created_at
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
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
