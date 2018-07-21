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
    
    @IBOutlet weak var loginPanel: UIStackView!
    @IBOutlet weak var userID: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func goToMyActivity(_ sender: Any) {
        if(UserInfo.ifLogin){            performSegue(withIdentifier: "goToMyActivity", sender: self)
        }
        
    }
    
    @IBAction func goToMyHobby(_ sender: Any) {
        if(UserInfo.ifLogin){
            
            performSegue(withIdentifier: "goToMyHobby", sender: self)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        if(UserInfo.ifLogin){
            userName.text=UserInfo.userName
           loginPanel.isHidden=true
            
            // userID.text=UserInfo.id
        }
        else{
            userName.text="请登录"
            loginPanel.isHidden=false
           // userID.text=""
        }
    }


    @IBAction func goToJoinedActivity(_ sender: Any) {
        if(UserInfo.ifLogin){
            
            performSegue(withIdentifier: "goToJoinedActivity", sender: self)
        }
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
