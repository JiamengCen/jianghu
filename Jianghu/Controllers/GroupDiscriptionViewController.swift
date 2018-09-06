//
//  GroupDiscriptionViewController.swift
//  Jianghu
//
//  Created by Jiameng Cen on 19/7/18.
//  Copyright © 2018 InternationalTradeMaster. All rights reserved.
//

import UIKit

class GroupDiscriptionViewController: UIViewController {

    @IBOutlet weak var groupDiscription: UIView!
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var joinGroup: UIButton!
    @IBOutlet weak var backgroundImg: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func start_chat(_ sender: Any) {
        performSegue(withIdentifier: "chat", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination=segue.destination as? ContactViewController{
            if(UserInfo.myInfo?.id==2){
                destination.another_user_id = "1";
            }
            else{
                destination.another_user_id = "2";
            }
            
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
