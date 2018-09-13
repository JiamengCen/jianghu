//
//  QRPageController.swift
//  Jianghu
//
//  Created by WANG, Yanqi on 2018/5/16.
//  Copyright © 2018年 InternationalTradeMaster. All rights reserved.
//

import UIKit

class QRPageController: UIViewController {
    @IBOutlet weak var Qr: UIImageView!
    @IBOutlet weak var activityTitle: UILabel!
    
    @IBOutlet weak var congratulation: UILabel!
    var activity:JoinActivity?
    var basicInfo=[JoinedActivityInfo]();
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }
    
    override func viewDidLoad() {
        let actStr = String(activity!.id)
        let userInfo = String(UserInfo.myInfo!.id)
        let QRCreate = userInfo + "|" + actStr
        Qr.image  = generateQRCode(from: QRCreate)
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

import Foundation

struct JoinedActivityInfo:Decodable {
    let activity_id:String;
    let user_id :String;
    let if_come:String;
    let qr:String;

}

