//
//  QRViewController.swift
//  Jianghu
//
//  Created by WANG, Yanqi on 2018/5/15.
//  Copyright © 2018年 InternationalTradeMaster. All rights reserved.
//

import UIKit
import AVFoundation

class QRViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate {
    
    var layer=AVCaptureVideoPreviewLayer();
    var session=AVCaptureSession()
    override func viewDidLoad() {
        super.viewDidLoad()
      
       // session=AVCaptureSession()
        let captureDevice=AVCaptureDevice.default(for: .video)
        do{
            let input=try AVCaptureDeviceInput(device: captureDevice!)
            session.addInput(input)
        }
        catch{
            
        }
        let output=AVCaptureMetadataOutput()
        session.addOutput(output)
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes=[AVMetadataObject.ObjectType.qr]
        layer=AVCaptureVideoPreviewLayer(session: session)
        layer.frame=view.layer.bounds
        view.layer.addSublayer(layer)
        session.startRunning()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects != nil && metadataObjects.count != 0{
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
                if object.type == AVMetadataObject.ObjectType.qr {
                    if(UserInfo.ifLogin){
                        if(object.stringValue?.isNumeric)!{
                            let viewChange=self.storyboard?.instantiateViewController(withIdentifier: "finishScan");
                            self.show(viewChange!, sender: self)
                        }
                        else{
                            let alert = UIAlertController(title: "提示", message: "二维码无效", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }                        
                        session.stopRunning()
                        return;
                        //self.present(viewChange!, animated:true, completion:nil)
                    }
                    else{
                        let viewChange=self.storyboard?.instantiateViewController(withIdentifier: "login");
                        self.show(viewChange!, sender: self)
                        session.stopRunning()
                        return;
                    }
                }
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





extension String {
    var isNumeric: Bool {
        guard self.characters.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self.characters).isSubset(of: nums)
    }
}
