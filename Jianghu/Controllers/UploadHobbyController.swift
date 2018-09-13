

import UIKit
import Photos

class UploadHobbyController:UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITextViewDelegate{
    //var reply = Reply(message)
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
    
    
    
    @IBOutlet var uploadButton: UIButton!
    var imgString="";
    @IBOutlet weak var collectionPicker: UIPickerView!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var imgContent: UICollectionView!
    @IBOutlet weak var cateTextField: UITextField!
    @IBOutlet weak var hobbyTextField: UITextField!
    @IBOutlet weak var contentView: UITextView!
    @IBOutlet weak var titleTextField: UITextField!
    
    var cates=Array<Cate>()
    var selectedCollection:Collection?
    var selectedCategory:Cate?
   
    @IBAction func uploadImage(_ sender: Any) {
        if(!(cateTextField.text?.isEmpty)! && !(hobbyTextField.text?.isEmpty)! && !(contentView.text?.isEmpty)! &&  !(titleTextField.text?.isEmpty)!){
            uploadButton.setTitle("请等待", for: .normal)
            uploadButton.setTitleColor(UIColor.lightGray, for: .normal)
            uploadButton.isUserInteractionEnabled=false;
            
            
           // let data=Comment(content: commentPost.text!, id: 0, user_id: hobby!.user_id, hobby_id: String(hobby!.id) , target_user: "", user_name: "", target_user_name: "")
            var img_array=Array<String>()
            for img in imgCollection{
                let imageData:Data = UIImageJPEGRepresentation(img, 0.1)!
                let imgString=imageData.base64EncodedString()
                img_array.append(imgString)
            }
            let data=UploadHobby(content: contentView.text!, image_url: img_array, collection_id:String( selectedCollection!.id), cate_id: String(selectedCategory!.id))
            let encoder=JSONEncoder();
            encoder.outputFormatting = .prettyPrinted
            let json=try? encoder.encode(data)
            print(String(data: json!, encoding: .utf8)!)
            guard let url=URL(string: "https://app.meljianghu.com/api/hobby/post") else{return}
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
                        print(printString)
                        let reply=try JSONDecoder().decode(Reply.self, from: data);
                        
                    } catch{
                        print(error);
                    }
                }
            }.resume();
            
        }
        self.performSegue(withIdentifier: "showHobbyfromUp", sender: self)
    }
    
   // let lable=["游玩","生活","校园","商务"];
   // let play=["球类","桌游","演唱","电竞","唱歌","","游艇","酒吧"]
   // let live=["美食","运动","健身","亲子","音乐","旅游","汽车","文化"]
   // let campus=["课程","大学","专业","雅思","PTE"]
   // let commercial=["法律","金融","科技","电商","设计","地产","政治"]
   // var subPicker:[[String]]=Array<Array<String>>()
   // var selectedSubPicker:[String]=Array<String>();
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
        if pickerView==self.categoryPicker{
            return cates.count
        }
        else{
            return Globals.collections.count
            
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView==self.categoryPicker{
            return  cates[row].name
        }
        else{
            return Globals.collections[row].name
            
        }
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView==self.collectionPicker{
            cates=Globals.getCateByCollectionID(collection_id: String(Globals.collections[row].id))
            cateTextField.text=Globals.collections[row].name
            selectedCollection=Globals.collections[row]
            hobbyTextField.text=nil
            collectionPicker.layer.zPosition=10;
            collectionPicker.isHidden=true
            categoryPicker.reloadAllComponents()
            hobbyTextField.isUserInteractionEnabled=true
            
        }
        else{
            hobbyTextField.text=cates[row].name
            selectedCategory=cates[row]
            categoryPicker.layer.zPosition=11;
            categoryPicker.isHidden=true;
        }
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField==self.cateTextField{
            self.view.endEditing(true)
            collectionPicker.isHidden=false
            return false
        }
        else if textField==self.hobbyTextField{
            if(self.cateTextField.text != nil){
                self.view.endEditing(true)
                categoryPicker.isHidden=false;
            }
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
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Placeholder"
            textView.textColor = UIColor.lightGray
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        uploadButton.setTitle("发布", for: .normal)
        uploadButton.setTitleColor(UIColor.red, for: .normal)
        uploadButton.isUserInteractionEnabled=true;
    }
    
    
    
    override func viewDidLoad() {
        photoStatus()
        cateTextField.delegate=self;
        hobbyTextField.delegate=self;
        hobbyTextField.isUserInteractionEnabled=false
        titleTextField.delegate=self;
        categoryPicker.delegate=self
        categoryPicker.dataSource=self
        collectionPicker.dataSource=self
        collectionPicker.delegate=self
        imgContent.delegate=self;
        imgContent.dataSource=self
        contentView.delegate=self
        contentView.text = "这一刻的想法"
        contentView.textColor = UIColor.lightGray
      //  contentView.layer.borderWidth=1.0;
      //  contentView.layer.borderColor=UIColor.lightGray.cgColor;
      //  contentView.layer.cornerRadius=contentView.frame.height/6;
        super.viewDidLoad()
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




