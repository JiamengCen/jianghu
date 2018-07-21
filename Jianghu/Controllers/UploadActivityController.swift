//
//  UploadActivityController.swift
//  Jianghu
//
//  Created by WANG, Yanqi on 2018/4/26.
//  Copyright © 2018年 InternationalTradeMaster. All rights reserved.
//

import UIKit

class UploadActivityController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView==cate{
            return categories.count
        }
        else{
            return type.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView==cate{
            return categories[row]
        }
        else{
            print (type[row])
            return type[row]
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView==cate{
            cateField.text=categories[row]
            picButton.isEnabled=true
            cate.isHidden=true
        }
        else{
            typeField.text=type[row];
            picButton.isEnabled=true
            typePicker.isHidden=true
        }
        
        
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if(textField==cateField){
            self.view.endEditing(true)
            cate.isHidden=false
            cate.layer.zPosition=11;
            picButton.isEnabled=false
            return false;
        }
        else if(textField==typeField){
            self.view.endEditing(true)
            typePicker.isHidden=false
            typePicker.layer.zPosition=11;
            picButton.isEnabled=false
            return false;
        }

        else{
            return true
        }
        
    }
    func createDatePicker() {
        
        // toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // done button for toolbar
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([done], animated: false)
        
        time.inputAccessoryView = toolbar
        time.inputView = timePicker
        
        // format picker for date
        timePicker.datePickerMode = .date
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
        timePicker.isHidden=true
    }
    
    

    
    let timePicker = UIDatePicker()
    //@IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var picButton: UIButton!
    @IBOutlet weak var typePicker: UIPickerView!
    @IBOutlet weak var typeField: UITextField!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var cateField: UITextField!
    @IBOutlet weak var cate: UIPickerView!
    @IBOutlet weak var activityTitle: UITextField!
    @IBOutlet weak var time: UITextField!
    @IBOutlet weak var place: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var content: UITextView!
    var categories=["玩乐","生活","校园","商务"];
    var type=["约活动","找活动"];
    @IBAction func upload(_ sender: Any) {
        if(!(activityTitle.text?.isEmpty)! && !(time.text?.isEmpty)! && !(place.text?.isEmpty)! && !(phone.text?.isEmpty)! && !(content.text?.isEmpty)! && !(cateField.text?.isEmpty)! && !(typeField.text?.isEmpty)!){
            var typeNumber="0";
            if(typeField.text=="找活动"){
                typeNumber="1";
            }
            let imageData:Data = UIImageJPEGRepresentation(img.image!, 0.1)!
            let imgString=imageData.base64EncodedString()
            let para="title="+activityTitle.text!+"&content="+content.text!+"&time="+time.text!+"&place="+place.text!+"&phone="+phone.text!+"&user_id="+UserInfo.id+"&file="+imgString+"&tag="+cateField.text!+"&if_big="+typeNumber;
            guard let url=URL(string: "http://jhapp.com.au/addActivity.php") else{return}
            var request=URLRequest(url: url)
            request.httpMethod="POST"
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
                            let viewChange=self.storyboard?.instantiateViewController(withIdentifier: "tab");
                            self.present(viewChange!, animated:true, completion:nil)
                        }
                    }
                }
            }.resume();
        }
        
        
    
    }
    @IBAction func choosePhoto(_ sender: Any) {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(myPickerController, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        cate.dataSource=self
        cate.delegate=self
        cate.layer.zPosition=11;
        cateField.delegate=self;
        typeField.delegate=self
        typePicker.delegate=self
        typePicker.dataSource=self
        typePicker.layer.zPosition=11;
        activityTitle.delegate=self;
        time.delegate=self;
        place.delegate=self;
        phone.delegate=self
        content.delegate=self;
        content.layer.borderWidth=1.0;
        content.layer.borderColor=UIColor.lightGray.cgColor;
        content.layer.cornerRadius=content.frame.height/6;
        createDatePicker()
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
        img.image=info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    //let myPickerController = UIImagePickerController()
   // myPickerController.delegate = self;
   // myPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
   // self.present(myPickerController, animated: true, completion: nil)

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
