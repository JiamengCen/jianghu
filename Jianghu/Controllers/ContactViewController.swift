//
//  ContactViewController.swift
//  Jianghu
//
//  Created by Jiameng Cen on 23/7/18.
//  Copyright © 2018 InternationalTradeMaster. All rights reserved.
//

import UIKit
import PusherChatkit

class ContactViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate {
    var messages = [Message]();
    var contact:Contact?
    var chatroom: ChatRoomData?
    @IBOutlet weak var contactTableView: UITableView!
    @IBOutlet weak var buttonPosition: NSLayoutConstraint!
    @IBOutlet weak var input: UITextView!
    @IBAction func send(_ sender: Any) {
        if(input.text != ""){
            self.view.endEditing(true)
            currentUser!.sendMessage(
                roomId: Int(contact!.room_id)!,
                text: input.text
            ) { messageId, error in
                guard error == nil else {
                    print("Error sending message: \(error!.localizedDescription)")
                    return
                }
                
            }
            input.text = ""
        }
        else{
            //input.text = ""
            
        }
       
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            buttonPosition.constant=keyboardSize.height*(-1);
            
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
            textView.text = "请输入消息..."
            textView.textColor = UIColor.lightGray
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // let contactCell = contactTableView.dequeueReusableCell(withIdentifier: "contactTableViewCell") as! ContactTableViewCell
      //  contactCell.anotherUserImg =
        if(messages[indexPath.row].message_sender_id != (UserInfo.myInfo?.chatkit_id)!){
            let contactCell = contactTableView.dequeueReusableCell(withIdentifier: "contactTableViewCell") as! ContactTableViewCell
            contactCell.Message.text = messages[indexPath.row].messageText
            
            contactCell.userImg.layer.cornerRadius=contactCell.userImg.frame.height/2
            contactCell.userImg.clipsToBounds=true
            contactCell.messageView.layer.cornerRadius=contactCell.messageView.frame.height/10
            contactCell.messageView.clipsToBounds=true;
            //self.contactTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            return contactCell;
          
            
        }
        else{
           let contactCell = contactTableView.dequeueReusableCell(withIdentifier: "myContactTableViewCell") as! MyContactViewCell
            contactCell.message.text = messages[indexPath.row].messageText
            contactCell.userImg.layer.cornerRadius=contactCell.userImg.frame.height/2
            contactCell.userImg.clipsToBounds=true
            contactCell.messageView.layer.cornerRadius=contactCell.messageView.frame.height/10
            contactCell.messageView.clipsToBounds=true;
            return contactCell
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.contactTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    var another_user_id: String?
    var currentUser: PCCurrentUser?
   /*
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
 */
    
    
    override func viewDidLoad() {
        input.text = "请输入消息..."
        input.textColor = UIColor.lightGray
        input.delegate=self
        contactTableView.delegate=self;
        contactTableView.dataSource=self;
        contactTableView.separatorStyle = .none
        contactTableView.allowsSelection = false
        
        super.viewDidLoad()
        print(self.view.frame.origin.y)
        NotificationCenter.default.addObserver(self, selector: #selector(ContactViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ContactViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        let data = ChatRoomData(user_one_id: String( (UserInfo.myInfo!.id)), user_two_id: another_user_id!)
        
        guard let url=URL(string: "https://app.meljianghu.com/api/chat/create_one_to_one_chat") else{return}
        let headers = [ "Content-Type": "application/json",
                        "Accept": "application/json",
                        "Authorization": "Bearer"+" " + UserInfo.token ]
        var request=URLRequest(url: url)
        request.httpMethod="POST"
        let encoder=JSONEncoder();
        encoder.outputFormatting = .prettyPrinted
        let json=try? encoder.encode(data)
        let para=String(data:json!, encoding: .utf8)
        print(para)
        request.httpBody = para!.data(using: String.Encoding.utf8);
        request.allHTTPHeaderFields = headers;
        let session=URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let data=data{
                do {
                    let printString=String(data: data, encoding: String.Encoding.utf8)
                    print(printString)
                    self.contact = try JSONDecoder().decode(Contact.self, from: data)
                    self.chat()
                  
                    
                    
                } catch{
                    print(error);
                }
            }
            }.resume();
        
        
    }
    
    func chat(){
        let tokenProvider = PCTokenProvider(
            url: "https://app.meljianghu.com/api/chat/get_token",
            requestInjector: { req in
                req.addHeaders(["Content-Type": "application/json",
                                "Accept": "application/json",
                                "Authorization": "Bearer"+" " + UserInfo.token])
                return req
        }
        )
        
        let chatManager = ChatManager(
            instanceLocator: "v1:us1:8d67a96f-8562-4da4-9e53-97099ce7c73c",
            tokenProvider: tokenProvider,
            userId: (UserInfo.myInfo?.chatkit_id)!
        )
        
        chatManager.connect(delegate: self) { [unowned self] currentUser, error in
            guard error == nil else {
                
                print("Error connecting: \(error!.localizedDescription)")
                return
            }
            print("Connected!")
            
            guard let currentUser = currentUser else { return }
            self.currentUser = currentUser
        }
        // Do any additional setup after loading the view.
        chatManager.connect(delegate: self) { [unowned self] currentUser, error in
            guard error == nil else {
                print("Error connecting: \(error!.localizedDescription)")
                return
            }
            print("Connected!")
            
            guard let currentUser = currentUser else { return }
            self.currentUser = currentUser
            
            for room in currentUser.rooms{
                currentUser.subscribeToRoom(room: room, roomDelegate: self)
            }
        }
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



extension ContactViewController: PCChatManagerDelegate,PCRoomDelegate {
    func newMessage(message: PCMessage) {
        print(message.text)
        messages.append(Message(message_sender_id: message.sender.id, messageText: message.text))
        print(messages.count);
        DispatchQueue.main.async {
            self.contactTableView.reloadData()
            let indexPath=self.contactTableView.index
            //self.contactTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            let lastSectionIndex = self.contactTableView!.numberOfSections - 1
            
            // Then grab the number of rows in the last section
            let lastRowIndex = self.contactTableView!.numberOfRows(inSection: lastSectionIndex) - 1
            
            // Now just construct the index path
            let pathToLastRow = IndexPath(row: lastRowIndex, section: lastSectionIndex)
            self.contactTableView.scrollToRow(at: pathToLastRow, at: .bottom, animated: true)
        }
        
        //print("\(message.sender.id) sent \(message.text!)")
        
    }
}
