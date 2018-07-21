//
//  LoginController.swift
//  Jianghu
//
//  Created by WANG, Yanqi on 2018/4/17.
//  Copyright © 2018年 InternationalTradeMaster. All rights reserved.
//

import UIKit
class LoginController:UIViewController,UITextFieldDelegate{
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBAction func login(_ sender: Any) {
        if( !(phone.text?.isEmpty)! && !(password.text?.isEmpty)!){
            guard let url=URL(string: "http://jhapp.com.au/CustomerLogin.php") else{return}
            var request=URLRequest(url: url)
            request.httpMethod="POST"
            let para="phone="+phone.text!+"&password="+password.text!
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
                            UserInfo.id = result?["id"] as! String
                            UserInfo.userName=result?["nickname"]as! String
                            UserInfo.ifLogin=true;
                            let viewChange=self.storyboard?.instantiateViewController(withIdentifier: "tab");
                            self.present(viewChange!, animated:true, completion:nil)
                        }
                    }
                }
                
            }.resume();
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
        phone.delegate=self
        password.delegate=self
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
}
