//
//  RegController.swift
//  Jianghu
//
//  Created by WANG, Yanqi on 2018/4/17.
//  Copyright © 2018年 InternationalTradeMaster. All rights reserved.
//

import UIKit
import SystemConfiguration

class RegController:UIViewController,UITextFieldDelegate{
    var replies=[Reply]()
    @IBOutlet weak var nickname: UITextField!
    @IBOutlet weak var mail: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var password_confirm: UITextField!
    
    @IBAction func register(_ sender: Any) {
        
        if(!(nickname.text?.isEmpty)! && !(phone.text?.isEmpty)! && !(password.text?.isEmpty)! && !(mail.text?.isEmpty)!){
         
            print(validateEmail(enteredEmail: mail.text!))
            if(((password.text?.count)!) >= 6) && ((phone.text?.count)! == 10) && (validateEmail(enteredEmail: (mail.text)!) &&
                password.text == password_confirm.text){
                let registerData=Register(name: nickname.text!, email:mail.text!, phone: phone.text!, password: password.text!, password_confirmation: password_confirm.text!)
                let encoder=JSONEncoder();
                encoder.outputFormatting = .prettyPrinted
                let json=try? encoder.encode(registerData)
                print(String(data: json!, encoding: .utf8)!)
                guard let url=URL(string: "https://app.meljianghu.com/api/user/register") else{return}
                let headers = [ "Content-Type": "application/json",
                                "Accept": "application/json"]
                var request=URLRequest(url: url)
                request.httpMethod="POST"
                let para=String(data: json!, encoding: .utf8)
                request.httpBody = para!.data(using: String.Encoding.utf8);
                request.allHTTPHeaderFields = headers;
                let session=URLSession.shared
                session.dataTask(with: request) { (data, response, error) in
                    if let responseData=data{
                        do {
                            //let printString=String(data: data, encoding: String.Encoding.utf8)
                            //print(printString)
                            print(type(of: responseData))
                            //let reply = try JSONDecoder().decode(Reply.self, from: data)
                            guard let responseObj = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String:Any] else {
                                print ("error")
                                return
                            }
                            print(responseObj)
                            print (type(of: responseObj))
                            print(responseObj["message"])
                            print(type(of: responseObj["message"]))
                            if let messageStr = responseObj["message"] as? String {
                                print(messageStr)
                                if (messageStr == "success") {
                                    print ("success")
                                    DispatchQueue.main.async {
                                        let viewChange=self.storyboard?.instantiateViewController(withIdentifier: "login");
                                        self.present(viewChange!, animated:true, completion:nil)
                                    }
                                } else {
                                    DispatchQueue.main.async {
                                         self.displayMyAlertMessage(userMesaage: messageStr)
                                    }
                                    print("failure")
                                }
                            }
                        }
                        catch{
                            print(error);
                            DispatchQueue.main.async {
                                self.displayMyAlertMessage(userMesaage: error as! String)
                            }
                        }
                    }
                    }.resume();
            }
            else{
                self.displayMyAlertMessage(userMesaage: "请确认号码为10位|请确认密码大于6位|请确认密码一致")
            }
            } else {
            self.displayMyAlertMessage(userMesaage: "所填信息不能为空")
        }
    }
    
    func validateEmail(enteredEmail:String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }
    
    func showAlert() {
        if !isInternetAvailable() {
            let alert = UIAlertController(title: "提示", message: "网络未连接", preferredStyle: .alert)
            let action = UIAlertAction(title: "好的", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    @IBOutlet weak var email: UITextField!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func displayMyAlertMessage(userMesaage:String){
        var myAlert = UIAlertController(title:"提示",message:userMesaage,preferredStyle:UIAlertControllerStyle.alert);
        let okAction = UIAlertAction(title:"Ok",style:UIAlertActionStyle.default,handler:nil);
        myAlert.addAction(okAction)
        self.present(myAlert,animated:true,completion:nil)
        //self.present(_, myAlert,animated, flag: true,completion: (() -> Void)? = nil);
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        nickname.delegate=self
        phone.delegate=self
        password.delegate=self
        password_confirm.delegate=self
    }
}

