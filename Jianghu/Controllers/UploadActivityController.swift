//
//  UploadActivityController.swift
//  Jianghu
//
//  Created by WANG, Yanqi on 2018/4/26.
//  Copyright © 2018年 InternationalTradeMaster. All rights reserved.
//

import UIKit
import Photos
class UploadActivityController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate {
    
    var selectedCateID = -1;
    var selectedCollectionID = -1;
    var selectedType = -1;
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == cate{
            return cates.count
        }
        else if pickerView == collectionPicker{
            return Globals.collections.count
        }
        else{
            return type.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == cate{
            return cates[row].name
        }
        else if pickerView == collectionPicker{
            return Globals.collections[row].name
        }
        else{
            return type[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == cate{
            cateField.text=cates[row].name
            selectedCateID=cates[row].id
            cate.isHidden=true
        }
        else if pickerView == collectionPicker{
            collectionField.text=Globals.collections[row].name
            selectedCollectionID=Globals.collections[row].id
            cates=Globals.getCateByCollectionID(collection_id: String(Globals.collections[row].id))
            cate.reloadAllComponents();
            collectionPicker.isHidden=true
        }
        else{
            typeField.text=type[row];
            if(type[row]=="约活动"){
                selectedType=1;
            }
            else{
                selectedType=2;
            }
            typePicker.isHidden=true
        }
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if(textField==cateField){
            self.view.endEditing(true)
            cate.isHidden=false
            cate.layer.zPosition=11;
          //  picButton.isEnabled=false
            return false;
        }
        else if(textField==typeField){
            self.view.endEditing(true)
            typePicker.isHidden=false
            typePicker.layer.zPosition=11;
          //  picButton.isEnabled=false
            return false;
        }

        else if(textField==collectionField){
            self.view.endEditing(true)
            collectionPicker.isHidden=false
            collectionPicker.layer.zPosition=11;
           // picButton.isEnabled=false
            return false;
        }
        else{
            return true
        }
        
    }
    func createDatePicker(field: UITextField) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        
        if(field==time){
            let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
            toolbar.setItems([done], animated: false)
            field.inputAccessoryView = toolbar
            field.inputView = timePicker
            
            // format picker for date
            timePicker.datePickerMode = .date
        }
        else if(field==end){
            let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedEndTime))
            toolbar.setItems([done], animated: false)
            field.inputAccessoryView = toolbar
            field.inputView = timePickerEnd
            
            // format picker for date
            timePickerEnd.datePickerMode = .date
        }
        // done button for toolbar
        
        
       
    }
    
    @objc func donePressed() {
        // format date
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.dateFormat="yyyy-MM-dd"
        let dateString = formatter.string(from: timePicker.date)
        
        time.text = "\(dateString)"
        self.view.endEditing(true)
        timePicker = UIDatePicker()
        timePicker.isHidden=true
        
    }
    
    @objc func donePressedEndTime() {
        // format date
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.dateFormat="yyyy-MM-dd"
        let dateString = formatter.string(from: timePickerEnd.date)
        
        end.text = "\(dateString)"
        print("开始时间")
        print(end.text)
        self.view.endEditing(true)
        timePickerEnd = UIDatePicker()
        timePickerEnd.isHidden=true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        uploadButton.setTitle("发布", for: .normal)
        uploadButton.setTitleColor(UIColor.red, for: .normal)
        uploadButton.isUserInteractionEnabled=true
    }

    
    var timePicker = UIDatePicker()
    var timePickerEnd = UIDatePicker()
    //@IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var end: UITextField!
    @IBOutlet weak var imgBottom: UIImageView!
    @IBOutlet weak var collectionField: UITextField!
    @IBOutlet weak var collectionPicker: UIPickerView!
    @IBOutlet var uploadButton: UIButton!
    @IBOutlet weak var picButton: UIButton!
    @IBOutlet weak var typePicker: UIPickerView!
    @IBOutlet weak var typeField: UITextField!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var cateField: UITextField!
    @IBOutlet weak var cate: UIPickerView!
    @IBOutlet weak var activityTitle: UITextField!
    @IBOutlet weak var time: UITextField!
    @IBOutlet weak var place: UITextField!
    @IBOutlet weak var content: UITextView!
    var cates=Array<Cate>()
    var type=["约活动","找活动"];
    var topPickerController = UIImagePickerController()
    var bottomPickerController = UIImagePickerController()
    @IBAction func upload(_ sender: Any) {
        if(!(activityTitle.text?.isEmpty)! && !(time.text?.isEmpty)! && !(place.text?.isEmpty)! && !(content.text?.isEmpty)! && !(cateField.text?.isEmpty)! && !(typeField.text?.isEmpty)!
            && !(collectionField.text?.isEmpty)! && !(end.text?.isEmpty)!){
            uploadButton.setTitle("请等待", for: .normal)
            uploadButton.setTitleColor(UIColor.lightGray, for: .normal)
            uploadButton.isUserInteractionEnabled=false
            
            let imageData_top:Data = UIImageJPEGRepresentation(img.image!, 0.1)!
            let imgString_top=imageData_top.base64EncodedString()
            
            let imageData_bottom = UIImageJPEGRepresentation(imgBottom.image!, 0.1)!
            let imgString_bottom = imageData_bottom.base64EncodedString()
            let data=ActivityUpload(content: content.text!, title: activityTitle.text!, user_id: String((UserInfo.myInfo?.id)!) , collection_id: String(selectedCollectionID), cate_id: String(selectedCateID) , address: place.text!, start_time: time.text!, end_time: end.text!, img_url_top: imgString_top, img_url_bottom: imgString_bottom, type: String(selectedType))
            let encoder=JSONEncoder();
            encoder.outputFormatting = .prettyPrinted
            let json=try? encoder.encode(data)
            print(String(data: json!, encoding: .utf8)!)
            guard let url=URL(string: "https://app.meljianghu.com/api/activity/post") else{return}
            let headers = [ "Content-Type": "application/json",
                            "Accept": "application/json",
                            "Authorization": "Bearer"+" " + UserInfo.token ]
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
                        //print(printString)
                        let reply = try JSONDecoder().decode(Reply.self, from: data)
                        if(reply.message=="success"){
                            DispatchQueue.main.async {
                                let viewChange=self.storyboard?.instantiateViewController(withIdentifier: "tab");
                                self.present(viewChange!, animated:true, completion:nil)
                            }
                        }
                    } catch{
                        print(error);

                    }
                }
                }.resume();
            
        }
        else{
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "提示", message: "请填满所有信息", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "好的", style: UIAlertActionStyle.default, handler: nil))
                alert.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func choosePhotoBottom(_ sender: Any) {
        bottomPickerController = UIImagePickerController()
        bottomPickerController.delegate = self
        bottomPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(bottomPickerController, animated: true, completion: nil)

    }
    @IBAction func choosePhoto(_ sender: Any) {
        topPickerController = UIImagePickerController()
        topPickerController.delegate = self
        topPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(topPickerController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        photoStatus()
        cate.dataSource=self
        cate.delegate=self
        cate.layer.zPosition=11;
        collectionField.delegate=self
        collectionPicker.delegate=self
        cateField.delegate=self;
        typeField.delegate=self
        typePicker.delegate=self
        typePicker.dataSource=self
        typePicker.layer.zPosition=11;
        activityTitle.delegate=self;
        time.delegate=self;
        place.delegate=self;
        content.delegate=self;
        content.layer.borderWidth=1.0;
        content.layer.borderColor=UIColor.lightGray.cgColor;
        content.layer.cornerRadius=content.frame.height/6;
        createDatePicker(field: time)
        createDatePicker(field: end)
        //timePicker.isHidden=true
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if(picker==topPickerController){
            img.image=info[UIImagePickerControllerOriginalImage] as? UIImage
            self.dismiss(animated: true, completion: nil)
        }
        else{
            imgBottom.image=info[UIImagePickerControllerOriginalImage] as? UIImage
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    func photoStatus(){
        let status = PHPhotoLibrary.authorizationStatus()
        if( status == .authorized){
        }
        else if (status == .restricted || status == .denied){
            let alertController = UIAlertController(title: "提示",
                                                    message: "需要允许访问相册权限方可上传图片",
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
        else if (status == .notDetermined){  //首次使用
            PHPhotoLibrary.requestAuthorization({  (firstStatus) in
                let isTrue = (firstStatus == .authorized)
                if isTrue {
                    print("首次允许")
                    
                } else {
                    print("首次不允许")
                }
            })
        }
    }
    
    
}
