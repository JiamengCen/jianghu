//
//  LoginController.swift
//  Jianghu
//
//  Created by WANG, Yanqi on 2018/4/17.
//  Copyright © 2018年 InternationalTradeMaster. All rights reserved.
//

import UIKit
import SystemConfiguration

class LoginController:UIViewController,UITextFieldDelegate{
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBAction func login(_ sender: Any) {
        if( !(phone.text?.isEmpty)! && !(password.text?.isEmpty)!){
            let data=LoginData(client_id: 2, client_secret: "FIzpbefnLtCC3pRUCtiZCfEoqqUzzrLVxpvcFBOT", grant_type: "password", scope: "*", username: phone.text!, password: password.text!)
            //let data=Register(name: nickname.text!, email:mail.text! , phone: phone.text!, password: password.text!)
            let encoder=JSONEncoder();
            encoder.outputFormatting = .prettyPrinted
            let json=try? encoder.encode(data)
            print(String(data: json!, encoding: .utf8)!)
            guard let url=URL(string: "https://app.meljianghu.com/oauth/token") else{return}
            let headers = [ "Content-Type": "application/json",
                            "Accept": "application/json"]
               // ,"authorization": "Bearer"+" "+UserInfo.token]
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
                        let token = try JSONDecoder().decode(Token.self, from: data)
                        UserInfo.token=token.access_token
                        self.getMyInfo()
                      
                    } catch{
                        DispatchQueue.main.async {
                            self.displayMyAlertMessage(userMesaage:"请输入正确的电话号码或密码");
                        }
                        print(error);
                        //return;
                    }
                    
                }
                
                }.resume();
        }
        else{
            self.displayMyAlertMessage(userMesaage: "账号或密码不为空")
        }
        UserDefaults.standard.set(true, forKey: "isLogined")
        UserDefaults.standard.synchronize()
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
    
    func displayMyAlertMessage(userMesaage:String){
        var myAlert = UIAlertController(title:"提示",message:userMesaage,preferredStyle:UIAlertControllerStyle.alert);
        let okAction = UIAlertAction(title:"Ok",style:UIAlertActionStyle.default,handler:nil);
        myAlert.addAction(okAction)
        self.present(myAlert,animated:true,completion:nil)
        //self.present(_, myAlert,animated, flag: true,completion: (() -> Void)? = nil);
    }
    
    fileprivate func isLogined()-> Bool{
        return UserDefaults.standard.bool(forKey: "isLogined")
    }
    
    func getMyInfo(){
        guard let url=URL(string: "https://app.meljianghu.com/api/user/my_info") else{return}
        let headers = [ "Content-Type": "application/json",
                        "Accept": "application/json",
                        "Authorization":"Bearer"+" "+UserInfo.token]
        var request=URLRequest(url: url)
        request.httpMethod="GET"
        request.allHTTPHeaderFields = headers;
        let session=URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let data=data{
                do {
                    let info = try JSONDecoder().decode(UserInformation.self, from: data)
                    UserInfo.myInfo=info
                    DispatchQueue.main.async {
                        let viewChange=self.storyboard?.instantiateViewController(withIdentifier: "tab");
                        self.present(viewChange!, animated:true, completion:nil)
                    }
                } catch{
                    print(error);
                }
                
            }
           
            }.resume();
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
        self.showAlert()
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
}
