//
//  RegController.swift
//  Jianghu
//
//  Created by WANG, Yanqi on 2018/4/17.
//  Copyright © 2018年 InternationalTradeMaster. All rights reserved.
//

import UIKit

class RegController:UIViewController,UITextFieldDelegate{
    var replies=[Reply]()
    @IBOutlet weak var nickname: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBAction func register(_ sender: Any) {
        if(!(nickname.text?.isEmpty)! && !(phone.text?.isEmpty)! && !(password.text?.isEmpty)!){
            
            
            guard let url=URL(string: "http://jhapp.com.au/CustomerReg.php") else{return}
            var request=URLRequest(url: url)
            request.httpMethod="POST"
            let para="nickname="+nickname.text!+"&phone="+phone.text!+"&password="+password.text!
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
                            let viewChange=self.storyboard?.instantiateViewController(withIdentifier: "login");
                            //self.show(viewChange!, sender: self)
                            self.present(viewChange!, animated:true, completion:nil)
                        }
                    }
                    
                }
                
            }.resume();
            
            
           // print(result["reply"])
            
        }
        else{
            print("1234");
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        nickname.delegate=self
        phone.delegate=self
        password.delegate=self
    }
}

