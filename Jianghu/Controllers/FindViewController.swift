//
//  FindViewController.swift
//  Jianghu
//
//  Created by Jiameng Cen on 7/9/18.
//  Copyright © 2018 InternationalTradeMaster. All rights reserved.
//

import UIKit
import AVFoundation

class FindViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate {

    @IBAction func scan(_ sender: Any) {
        checkCamera()
    }
    
    func checkCamera() {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authStatus {
        case .authorized: requestCameraPermission()
        DispatchQueue.main.async {
            self.gotoQRView()
            }
        case .denied:()
        DispatchQueue.main.async {
            self.presentCameraSettings()
           self.gotoQRView()
            }
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video)  { success in
                DispatchQueue.main.async {
                    if success {
                        print("Permission granted, proceed")
                    }else{
                        print("Permission denied")
                    }
                    self.gotoQRView()
                }
            }
        default: ()
        DispatchQueue.main.async {
            self.alertToEncourageCameraAccessInitially()
            self.gotoQRView()
            }
            
        }
    }
    
    func requestCameraPermission(){
        AVCaptureDevice.requestAccess(for: .video, completionHandler: {accessGranted in
            guard accessGranted == true else { return }
        })
    }
    
    func presentCameraSettings() {
        let alertController = UIAlertController(title: "错误",
                                                message: "相机访问被拒，无法扫码",
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "取消", style: .default))
        alertController.addAction(UIAlertAction(title: "去设置", style: .cancel) { _ in
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
            title: "重要提示",
            message: "扫码需要先允许使用相机权限",
            preferredStyle: UIAlertControllerStyle.alert
        )
        alert.addAction(UIAlertAction(title: "取消", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "允许访问相机获取二维码", style: .cancel) { _ in
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: { _ in
                    // Handle
                })
            }
        })
        present(alert, animated: true, completion: nil)
    }
    
    func gotoQRView(){
        let viewChange=self.storyboard?.instantiateViewController(withIdentifier: "QRViewController");
        self.show(viewChange!, sender: self)
    }
    
    override func viewDidLoad() {
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
