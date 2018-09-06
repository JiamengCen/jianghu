//
//  CreditsViewController.swift
//  Jianghu
//
//  Created by Jiameng Cen on 17/7/18.
//  Copyright © 2018 InternationalTradeMaster. All rights reserved.
//

import UIKit

class CreditsViewController: UIViewController {
    var credit:Credit?
    var currentCredit:String?

    @IBOutlet weak var sevenView: UIView!
    @IBOutlet weak var SixView: UIView!
    @IBOutlet weak var fiveView: UIView!
    @IBOutlet weak var fourView: UIView!
    @IBOutlet weak var threeView: UIView!
    @IBOutlet weak var twoView: UIView!
    @IBOutlet weak var oneView: UIView!
    @IBOutlet weak var buttonView: UIStackView!
    @IBOutlet weak var timeClock: UILabel!
    @IBOutlet weak var silverLabel: UILabel!
    @IBOutlet weak var creditLabel: UILabel!
    @IBOutlet weak var sevenyes: UIImageView!
    @IBAction func sevenDay(_ sender: Any) {
        sevenyes.isHidden=false
    }
    @IBOutlet weak var sixyes: UIImageView!
    @IBAction func sixDay(_ sender: Any) {
        sixyes.isHidden=false
    }
    @IBOutlet weak var fiveyes: UIImageView!
    @IBAction func fiveDay(_ sender: Any) {
        fiveyes.isHidden=false
    }
    @IBAction func oneDay(_ sender: Any) {
        oneYes.isHidden = false
        currentCredit = String(Int((UserInfo.myInfo?.points)!)!+10)
        creditLabel.text = currentCredit!+"分"
        self.twoView.isUserInteractionEnabled = false
        self.creditUpdate()
    }
    @IBOutlet weak var fouryes: UIImageView!
   
    @IBAction func fourDay(_ sender: Any) {
        fouryes.isHidden = false
    }
    
    @IBAction func threeDay(_ sender: Any) {
        threeyes.isHidden = false
    }
    @IBOutlet weak var threeyes: UIImageView!
    @IBOutlet weak var oneYes: UIImageView!
    @IBAction func twoDay(_ sender: Any) {
        twoYes.isHidden = false
    }
    @IBOutlet weak var twoYes: UIImageView!

    func creditUpdate(){
        let data=UploadCredit(updateCredit: currentCredit!)
        let encoder=JSONEncoder();
        encoder.outputFormatting = .prettyPrinted
        let json=try? encoder.encode(data)
        print(String(data: json!, encoding: .utf8)!)
        guard let url=URL(string: "https://app.meljianghu.com/api/user/add_points") else{return}
        let headers = [ "Content-Type": "application/json",
                        "Accept": "application/json",
                        "Authorization": "Bearer"+" " + UserInfo.token]
        var request=URLRequest(url: url)
        request.httpMethod="POST"
        let para=String(data: json!, encoding: .utf8)
        request.httpBody = para!.data(using: String.Encoding.utf8);
        request.allHTTPHeaderFields = headers;
        let session=URLSession.shared
        session.dataTask(with: request){ (data, response, error) in
            if let data=data{
                do{
                    let printString=String(data: data, encoding:String.Encoding.utf8)
                    print(printString)
                    /*let token = try JSONDecoder().decode(Token.self, from: data)
                    UserInfo.token=token.access_token
                    self.getMyInfo()*/
                    
                }catch{
                    print(error);
                }
            }
        }.resume();
    }

    override func viewDidLoad() {
        oneYes.isHidden = true
        twoYes.isHidden = true
        threeyes.isHidden = true
        fouryes.isHidden = true
        fiveyes.isHidden=true
        sixyes.isHidden=true
        sevenyes.isHidden=true
        //fiveyes.isHidden = true
        //sixyes.isHidden = true
        //sevenyes.isHidden = true
        if(UserInfo.token != ""){
            creditLabel.text = String(Int((UserInfo.myInfo?.points)!)!)+"分"
        }
        else{
            let viewChange=self.storyboard?.instantiateViewController(withIdentifier: "login");
            self.show(viewChange!, sender: self)
        }
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
