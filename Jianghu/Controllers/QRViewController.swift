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
        //checkCamera()
        //let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video);
        super.viewDidLoad()
        session=AVCaptureSession()
            
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

    func checkCamera() {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authStatus {
        case .authorized: requestCameraPermission()
        case .denied:()
            DispatchQueue.main.async {
                self.presentCameraSettings()
            }
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video)  { success in
                DispatchQueue.main.async {
                    if success {
                        print("Permission granted, proceed")
                    }else{
                        print("Permission denied")
                    }
                }
            }
        default: ()
         DispatchQueue.main.async {
            self.alertToEncourageCameraAccessInitially()
        }
       
        }
    }
    
    func requestCameraPermission(){
        AVCaptureDevice.requestAccess(for: .video, completionHandler: {accessGranted in
            guard accessGranted == true else { return }
        })
    }
    
    func presentCameraSettings() {
        let alertController = UIAlertController(title: "Error",
                                                message: "Camera access is denied",
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default))
        alertController.addAction(UIAlertAction(title: "Settings", style: .cancel) { _ in
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: { _ in
                    // Handle
                })
            }
        })
        
        present(alertController, animated: true)
    }
    
    func alertToEncourageCameraAccessInitially(){
        let alert = UIAlertController(
            title: "IMPORTANT",
            message: "Camera access required for capturing photos!",
            preferredStyle: UIAlertControllerStyle.alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Allow Camera", style: .cancel) { _ in
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: { _ in
                    // Handle
                })
            }
        })
        present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if(UserInfo.token != ""){
            return
        }
        else{
            let viewChange=self.storyboard?.instantiateViewController(withIdentifier: "login");
            self.show(viewChange!, sender: self)
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if metadataObjects != nil && metadataObjects.count != 0{
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
                if object.type == AVMetadataObject.ObjectType.qr {
                    if(UserInfo.token != ""){
                        /*let viewChange=self.storyboard?.instantiateViewController(withIdentifier: "finishScan");
                        self.show(viewChange!, sender: self) */
                        let data = object.stringValue
                        let encoder=JSONEncoder();
                        let dataList = data!.components(separatedBy: "|")
                        print (dataList[0])
                        print (dataList[1])
                        guard let url=URL(string: "https://app.meljianghu.com/api/activity/check/" + dataList[0] + "/" + dataList[1])else{return}
                        
                        let headers = [ "Content-Type": "application/json",
                                        "Accept": "application/json",
                                        "Authorization": "Bearer"+" " + UserInfo.token ]
                        var request=URLRequest(url: url)
                        request.httpMethod="GET"
                        //let para=String(data: json!, encoding: .utf8)
                        //request.httpBody = para!.data(using: String.Encoding.utf8);
                        request.allHTTPHeaderFields = headers;
                        let sessionUrl=URLSession.shared
                        sessionUrl.dataTask(with: request) { (data, response, error) in
                            if let data=data{
                                do {
                                    let printString=String(data: data, encoding: String.Encoding.utf8)
                                    print(printString)
                                    let reply = try JSONDecoder().decode(Reply.self, from: data)
                                    if(reply.message=="success"){

                                        DispatchQueue.main.async {
                                            self.performSegue(withIdentifier: "checkSuccess", sender:nil)

                                            //performSegue(withIdentifier: "checkSuccess", sender:QRViewController.self)
                                           // let viewChange=self.storyboard?.instantiateViewController(withIdentifier: "finishScan");
                                           // self.present(viewChange!, animated:true, completion:nil)
                                        }
                                    }
                                    else{
                                        DispatchQueue.main.async {
                                            // create the alert
                                            let alert = UIAlertController(title: "未能成功扫码", message: "请重试", preferredStyle: UIAlertControllerStyle.alert)
                                            // add the actions (buttons)
                                            alert.addAction(UIAlertAction(title: "了解", style: UIAlertActionStyle.default, handler: nil))
                                            alert.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil))
                                            // show the alert
                                            self.present(alert, animated: true, completion: nil)
                                        }
                                    }
                                } catch{
                                    print(error);
                                }
                            }
                            }.resume();
                       /* if(object.stringValue?.isNumeric)!{
                            let viewChange=self.storyboard?.instantiateViewController(withIdentifier: "finishScan");
                            self.show(viewChange!, sender: self)
                        }
                        else{
                            let alert = UIAlertController(title: "提示", message: "二维码无效", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }          */
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

extension AVCaptureDevice {
    enum AuthorizationStatus {
        case justDenied
        case alreadyDenied
        case restricted
        case justAuthorized
        case alreadyAuthorized
    }
    
    class func authorizeVideo(completion: ((AuthorizationStatus) -> Void)?) {
        AVCaptureDevice.authorize(mediaType: AVMediaType.video.rawValue, completion: completion)
    }
    
    class func authorizeAudio(completion: ((AuthorizationStatus) -> Void)?) {
        AVCaptureDevice.authorize(mediaType: AVMediaType.audio.rawValue, completion: completion)
    }
    
    private class func authorize(mediaType: String, completion: ((AuthorizationStatus) -> Void)?) {
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType(rawValue: mediaType))
        switch status {
        case .authorized:
            completion?(.alreadyAuthorized)
        case .denied:
            completion?(.alreadyDenied)
        case .restricted:
            completion?(.restricted)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType(rawValue: mediaType), completionHandler: { (granted) in
                if(granted) {
                    completion?(.justAuthorized)
                }
                else {
                    completion?(.justDenied)
                }
            })
        }
    }
}
