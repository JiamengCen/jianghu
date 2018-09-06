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
    @IBAction func register(_ sender: Any) {
        if(!(nickname.text?.isEmpty)! && !(phone.text?.isEmpty)! && !(password.text?.isEmpty)! && !(mail.text?.isEmpty)!){
            
            let data=Register(name: nickname.text!, email:mail.text! , phone: phone.text!, password: password.text!)
            let encoder=JSONEncoder();
            encoder.outputFormatting = .prettyPrinted
            let json=try? encoder.encode(data)
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
                if let data=data{
                    do {
                        let printString=String(data: data, encoding: String.Encoding.utf8)
                        print(printString)
                        DispatchQueue.main.async {
                            let viewChange=self.storyboard?.instantiateViewController(withIdentifier: "login");
                            self.present(viewChange!, animated:true, completion:nil)
                        }
                    } catch{
                        print(error);
                        self.displayMyAlertMessage(userMesaage: error as! String)
                    }
                }
                }.resume();
        }
        else{
            self.displayMyAlertMessage(userMesaage: "所填信息不能为空")
        }
        
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
    }
}

