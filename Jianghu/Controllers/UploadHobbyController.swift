

import UIKit

class UploadHobbyController:UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITextViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgCollection.count+1;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=imgContent.dequeueReusableCell(withReuseIdentifier: "uploadImg", for: indexPath) as! UploadImgCell
        if(indexPath.row>imgCollection.count-1){
            
            cell.img.image=UIImage(named: "plus")
        }
        else{
            cell.img.image=imgCollection[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row>imgCollection.count-1{
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(myPickerController, animated: true, completion: nil)
        }
        else{
            imgCollection.remove(at: indexPath.row)
            imgContent.reloadData();
        }
    }
    
    
    
    var imgString="";
    @IBOutlet weak var catePicker: UIPickerView!
    @IBOutlet weak var hobbyPicker: UIPickerView!
    @IBOutlet weak var imgContent: UICollectionView!
    @IBOutlet weak var cateTextField: UITextField!
    @IBOutlet weak var hobbyTextField: UITextField!
    @IBOutlet weak var contentView: UITextView!
    @IBOutlet weak var titleTextField: UITextField!
   
    @IBAction func uploadImage(_ sender: Any) {
        if(!(cateTextField.text?.isEmpty)! && !(hobbyTextField.text?.isEmpty)! && !(contentView.text?.isEmpty)! &&  !(titleTextField.text?.isEmpty)!){
            var para="title="+titleTextField.text!+"&content="+contentView.text!+"&tag1="+cateTextField.text!+"&tag2="+hobbyTextField.text!+"&user_id="+UserInfo.id;
            for img in imgCollection{
                let imageData:Data = UIImageJPEGRepresentation(img, 0.1)!
                let imgString=imageData.base64EncodedString()
                para=para+"&file"+String(imgCollection.index(of: img)!)+"="+imgString
            }
            //let imageData:Data = UIImageJPEGRepresentation(img.image!, 0.1)!
           // imgString = imageData.base64EncodedString()
            
            guard let url=URL(string: "http://jhapp.com.au/addHobby.php") else{return}
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
    let lable=["游玩","生活","校园","商务"];
    let play=["球类","桌游","演唱","电竞","唱歌","摄影","游艇","酒吧"]
    let live=["美食","运动","健身","亲子","音乐","旅游","汽车","文化"]
    let campus=["课程","大学","专业","雅思","PTE"]
    let commercial=["法律","金融","科技","电商","设计","地产","政治"]
    var subPicker:[[String]]=Array<Array<String>>()
    var selectedSubPicker:[String]=Array<String>();
    var imgCollection:[UIImage]=Array<UIImage>();
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //img.image=info[UIImagePickerControllerOriginalImage] as? UIImage
        imgCollection.append((info[UIImagePickerControllerOriginalImage] as? UIImage)!)
        imgContent.reloadData()
        self.dismiss(animated: true, completion: nil)                
    }
    
    
    

    

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView==self.catePicker{
            return lable.count;
        }
        else{
            return selectedSubPicker.count
            
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView==self.catePicker{
            return lable[row]
        }
        else{
            return selectedSubPicker[row]
            
        }
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView==self.catePicker{
            selectedSubPicker=subPicker[row]
            cateTextField.text=lable[row]
            hobbyTextField.text=nil
            catePicker.layer.zPosition=10;
            catePicker.isHidden=true
            hobbyPicker.reloadAllComponents()
            
        }
        else{
            hobbyTextField.text=selectedSubPicker[row]
            hobbyPicker.layer.zPosition=11;
            hobbyPicker.isHidden=true;
        }
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField==self.cateTextField{
            self.view.endEditing(true)
            catePicker.isHidden=false
            return false
        }
        else if textField==self.hobbyTextField{
            self.view.endEditing(true)
            hobbyPicker.isHidden=false;
            return false
        }
        else{
            return true
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    override func viewDidLoad() {
        subPicker.append(play)
        subPicker.append(live)
        subPicker.append(campus)
        subPicker.append(commercial)
        cateTextField.delegate=self;
        hobbyTextField.delegate=self;
        titleTextField.delegate=self;
        catePicker.delegate=self;
        catePicker.dataSource=self;
        hobbyPicker.delegate=self;
        hobbyPicker.dataSource=self;
        imgContent.delegate=self;
        imgContent.dataSource=self
        contentView.delegate=self
        contentView.layer.borderWidth=1.0;
        contentView.layer.borderColor=UIColor.lightGray.cgColor;
        contentView.layer.cornerRadius=contentView.frame.height/6;
        super.viewDidLoad()
    }
    
}




