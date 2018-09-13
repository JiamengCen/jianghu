//
//  UserController.swift
//  Jianghu
//
//  Created by WANG, Yanqi on 2018/5/7.
//  Copyright © 2018年 InternationalTradeMaster. All rights reserved.
//

import UIKit

class UserController: UIViewController {

    @IBOutlet weak var userName: UILabel!
    
   // @IBOutlet weak var loginout: UIButton!
    @IBOutlet weak var plzLogin: UIButton!
    
   /* @IBAction func LoginOut(_ sender: Any) {
        UserInfo.myInfo=nil
        UserInfo.token=""
        let viewChange=self.storyboard?.instantiateViewController(withIdentifier: "tab");
        self.present(viewChange!, animated:true, completion:nil)
    }*/
    
    @IBAction func pleaseLogin(_ sender: Any) {
        if(UserInfo.token != ""){
            return
        }else{
            let viewChange=self.storyboard?.instantiateViewController(withIdentifier: "login");
            self.show(viewChange!, sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userName.text = UserInfo.myInfo?.name
        // Do any additional setup after loading the view.
    }
 

    @IBAction func goToMyActivity(_ sender: Any) {
        if(UserInfo.token != ""){
            performSegue(withIdentifier: "goToMyActivity", sender: self)
        }
    }
    
    @IBAction func goToMyHobby(_ sender: Any) {
        if(UserInfo.token != ""){
            performSegue(withIdentifier: "goToMyHobby", sender: self)
        }
    }
    
    @IBAction func goToJoinedActivity(_ sender: Any) {
        if(UserInfo.token != ""){
            performSegue(withIdentifier: "goToJoinedActivity", sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if(UserInfo.token != ""){
            return
        }
        else{
            let viewChange=self.storyboard?.instantiateViewController(withIdentifier: "login");
            self.show(viewChange!, sender: self)
        }
        
        if(UserInfo.token != ""){
            plzLogin.isHidden=true
            userName.text=UserInfo.myInfo?.name
            // userID.text=UserInfo.id
        }
        else{
            plzLogin.isHidden=false
            userName.text="请登录"
           // userID.text=""
        }
    }
}

