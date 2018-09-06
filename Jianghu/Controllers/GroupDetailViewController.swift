//
//  GroupDetailViewController.swift
//  Jianghu
//
//  Created by Jiameng Cen on 19/7/18.
//  Copyright © 2018 InternationalTradeMaster. All rights reserved.
//

import UIKit
import PusherChatkit

class GroupDetailViewController: UIViewController,UITextViewDelegate  {
    //UITableViewDelegate,UITableViewDataSource,
    @IBOutlet weak var buttomPosition: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.view.frame.origin.y)
        NotificationCenter.default.addObserver(self, selector: #selector(GroupDetailViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GroupDetailViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @IBAction func popupBottomMenu(_ sender: Any) {
        if(buttomPosition.constant==0){
            self.view.endEditing(true)
            buttomPosition.constant = -100
        }
        else{
            self.view.endEditing(true)
            buttomPosition.constant = 0
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            buttomPosition.constant=keyboardSize.height*(-1);
            
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            buttomPosition.constant=0;
        }
    }
    
   /* func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    } */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
