
import UIKit
import SDWebImage


class HobbyController:UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDelegate,UITableViewDataSource{
    
   // var currentSelectedIndexPath:IndexPath?;
    func startChat(){
        let alertController = UIAlertController(title: "联系人",
                                                message: nil,
                                                preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "发送消息", style: .default) { _ in
            self.performSegue(withIdentifier: "showContact", sender: self)
        })
        
        present(alertController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView==self.hobbyContent){
            return hobbyArticles.count
        }
        else{
            return cates.count
        }
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //var imgs=[UIImageView]();
        if(tableView == self.hobbyContent){
            
            let cell = hobbyContent.dequeueReusableCell(withIdentifier: "hobbyTableCell") as! HobbyTableViewCell
            cell.selectionStyle = .none
            
            cell.imgs.append(cell.img1)
            cell.imgs.append(cell.img2)
            cell.imgs.append(cell.img3)
            cell.imgs.append(cell.img4)
            cell.imgs.append(cell.img5)
            cell.imgs.append(cell.img6)
            for i in cell.imgs
            {
                let g = UITapGestureRecognizer(target: self, action: #selector(showBigPic))
                i.addGestureRecognizer(g)
               // currentSelectedIndexPath=indexPath
                i.isUserInteractionEnabled = true
            }
            
            //print( indexPath.row);
            //print(hobbyArticles.count)
            cell.user.text = hobbyArticles[indexPath.row].user_name
            let timeString=hobbyArticles[indexPath.row].created_at
            let dateFormatter=DateFormatter()
            dateFormatter.dateFormat="yyyy-MM-dd HH:mm:ss"
            let dateObj = dateFormatter.date(from: timeString)
            dateFormatter.dateFormat="dd/MM/yy"
            let displayedTime=dateFormatter.string(from: dateObj!)
            cell.time.text = displayedTime
            cell.content.text=hobbyArticles[indexPath.row].content
            cell.cate.text=hobbyArticles[indexPath.row].cate_name
            cell.cate.layer.cornerRadius=cell.cate.frame.height/10
            cell.head.layer.cornerRadius=cell.head.frame.height/2
            cell.head.layer.masksToBounds=true
            cell.chatButton.addTarget(self, action: #selector(goToChat), for: .touchUpInside)
            cell.commentButton.addTarget(self, action: #selector(goToComment), for: .touchUpInside)
            cell.unlikeButton.addTarget(self, action: #selector(clickUnLike), for: .touchUpInside)
            //cell.commentButton.addta
            let img_array = hobbyArticles[indexPath.row].image_url.components(separatedBy: "|");
            cell.imgCount=img_array.count
            let totalImageView=6;
            if(img_array.count<4){
                cell.imgStack2.isHidden=true;
                cell.totalStackHeight.constant=90
                
            }
            else{
                cell.imgStack2.isHidden=false;
                cell.totalStackHeight.constant=190
            }
            var  i=0
       //     print(img_array.count)
            while(i<totalImageView){
                if(i<img_array.count){
                    print(img_array[i])
                    //imgs[i].downloadedFrom(url: "http://app.meljianghu.com/storage/"+img_array[i])
                    cell.imgs[i].sd_setImage(with: URL(string: "https://app.meljianghu.com/storage/"+img_array[i]), placeholderImage: UIImage(named: ""))
                    cell.imgs[i].contentMode = .scaleAspectFill
                }
                else{
                    cell.imgs[i].image=nil
                    
                }
                i=i+1
            }

            return cell
        }
        else{
            let cell=dropdownMenu.dequeueReusableCell(withIdentifier: "dropdownItem", for: indexPath)
            cell.textLabel!.text=cates[indexPath.row].name
            
            return cell
        }
       
    }
    
    @objc func showBigPic(_ recognizer:UITapGestureRecognizer){
        //图片索引
        let index = recognizer.view!.tag
        let point=recognizer.location(in: self.hobbyContent)
        let indexPath = self.hobbyContent.indexPathForRow(at: point)
        /*let position:CGPoint = recognizer.convert(CGPoint.zero, to:self.hobbyContent)
        let indexPath = self.tableView.indexPathForRow(at: position)*/
        //进入图片全屏展示
        let cell = hobbyContent.cellForRow(at: indexPath!) as! HobbyTableViewCell
        let previewVC = ImagePreviewVC(images:cell.imgs, index: index, img_count: cell.imgCount)
        self.navigationController?.pushViewController(previewVC, animated: true)
    }
    
    @objc func goToChat(sender: UIButton!){
        let buttonPostion = sender.convert(sender.bounds.origin, to: hobbyContent)
        if let indexPath = hobbyContent.indexPathForRow(at: buttonPostion) {
            selectedHobby=hobbyArticles[indexPath.row]
        }
        
        if(UserInfo.token != ""){
            if(String((UserInfo.myInfo?.id)!) != (selectedHobby?.user_id)!){
                let alertController = UIAlertController(title: "联系人",
                                                        message: "",
                                                        preferredStyle: .actionSheet)
                alertController.addAction(UIAlertAction(title: "发送消息", style: .default) { _ in
                    
                    self.performSegue(withIdentifier: "showContact", sender: self)
                    
                })
                alertController.addAction(UIAlertAction(title: "取消", style: .cancel))
                present(alertController, animated: true)
            }
           
        }
        else{
            let viewChange=self.storyboard?.instantiateViewController(withIdentifier: "login");
            self.show(viewChange!, sender: self)
        }
    }
    
    @objc func goToComment(sender: UIButton!) {
        let buttonPostion = sender.convert(sender.bounds.origin, to: hobbyContent)
        
        if let indexPath = hobbyContent.indexPathForRow(at: buttonPostion) {
            selectedHobby=hobbyArticles[indexPath.row]
        }
        if(UserInfo.token != ""){
            performSegue(withIdentifier: "showComment", sender: sender)
        }
        else{
            let viewChange=self.storyboard?.instantiateViewController(withIdentifier: "login");
            self.show(viewChange!, sender: self)
        }
    }
    var click = 0
    @objc func clickUnLike(sender: UIButton!) {
         let buttonPostion = sender.convert(sender.bounds.origin, to: hobbyContent)
         let indexPath = hobbyContent.indexPathForRow(at: buttonPostion)
         let cell = hobbyContent.cellForRow(at: indexPath!) as! HobbyTableViewCell
         //cell.hobby = hobbyArticles[(indexPath?.row)!]
         //cell.unlikeButton.
        if(click==0){
            let data = HobbyLike(hobby_id: String(hobbyArticles[(indexPath?.row)!].id))
            let encoder=JSONEncoder();
            encoder.outputFormatting = .prettyPrinted
            let json=try? encoder.encode(data)
            print(String(data: json!, encoding: .utf8)!)
            guard let url=URL(string: "https://app.meljianghu.com/api/like/post") else{return}
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
                        let reply = try JSONDecoder().decode(Reply.self, from: data)
                        if(reply.message=="success"){
                            print("success")
                            DispatchQueue.main.async {
                                
                            }
                        }
                        else{
                            print("unsuccess")
                            DispatchQueue.main.async {
                                
                            }
                        }
                    } catch{
                        print(error);
                    }
                }
                }.resume();
            click=1
        }
        else{
            click = 0
            let data = HobbyLike(hobby_id: String(hobbyArticles[(indexPath?.row)!].id))
            let encoder=JSONEncoder();
            encoder.outputFormatting = .prettyPrinted
            let json=try? encoder.encode(data)
            print(String(data: json!, encoding: .utf8)!)
            guard let url=URL(string: "https://app.meljianghu.com/api/like/delete") else{return}
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
                        let reply = try JSONDecoder().decode(Reply.self, from: data)
                        if(reply.message=="success"){
                            print("success")
                            DispatchQueue.main.async {
                                
                            }
                        }
                        else{
                            print("unsuccess")
                            DispatchQueue.main.async {
                                
                            }
                        }
                    } catch{
                        print(error);
                    }
                }
                }.resume();
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView==self.nameView{
            return cates.count
            
        }
        else {
            return iconNav.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView==self.nameView{
            
            let hobbyNamesCell=nameView.dequeueReusableCell(withReuseIdentifier: "hobbyNames", for: indexPath) as! HobbyNameCell
            //hobbyNamesCell.hobbyNameLable.font=UIFont(name: "STXingkai", size: 16)
            hobbyNamesCell.hobbyNameLable.text=self.cates[indexPath.row].name;
         //   hobbyNamesCell.hobbyNameLable.textColor=UIColor.black;
            return hobbyNamesCell
        }
        else {
            let iconNavCell=iconNavView.dequeueReusableCell(withReuseIdentifier: "iconNavCell", for: indexPath) as!HobbyIconNavCell
            iconNavCell.text.text=iconNav[indexPath.row]
            iconNavCell.img.image=UIImage(named: "navIcon"+String(indexPath.row))
            iconNavCell.img.contentMode = .scaleAspectFill
            return iconNavCell
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,didSelectItemAt indexPath: IndexPath){
        if collectionView==self.nameView{
            let cell=collectionView.cellForItem(at: indexPath) as!HobbyNameCell
            for index in collectionView.indexPathsForVisibleItems{
                let allCellItem=collectionView.cellForItem(at: index) as!HobbyNameCell
                allCellItem.hobbyNameLable.textColor=UIColor.black
                if((allCellItem.layer.sublayers?.count)!>1){
                    allCellItem.layer.sublayers![1].removeFromSuperlayer()
                }
            }
            let border = CALayer()
            let borderWidth = CGFloat(2.0)
            border.borderColor = UIColor.red.cgColor
            border.frame = CGRect(x: cell.frame.size.width*0.3, y: cell.frame.size.height - borderWidth, width:  cell.frame.size.width*0.45, height: cell.frame.size.height)
            border.borderWidth = borderWidth
            cell.layer.addSublayer(border)
            cell.hobbyNameLable.textColor=UIColor.red
            
            loading.startAnimating()
            loading.isHidden=false
            hobbyContent.isHidden=true
            currentCateId=String(cates[indexPath.row].id);
            loadHobbies(cate_id:String(cates[indexPath.row].id))
        }
        else{
            if(indexPath.row==0){
                performSegue(withIdentifier: "showTopic", sender: self)
            }
            if(indexPath.row==1){
                performSegue(withIdentifier: "showService", sender: self)
            }
            if(indexPath.row==2){
                performSegue(withIdentifier: "showActivity", sender: self)
            }
            if(indexPath.row==3){
                performSegue(withIdentifier: "showFind", sender: self)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView==self.hobbyContent){
            //print("xxxxxxxxxxxxxxxxxxxxxxxxxxxx")
        }
        else{
            self.nameView.scrollToItem(at: indexPath, at: .left, animated: true)
            self.ifLoadFromDropDown=true
            dropDownIndexPath=indexPath
            loading.startAnimating()
            loading.isHidden=false
            hobbyContent.isHidden=true
            dropdownMenu.isHidden=true
            loadHobbies(cate_id:String(cates[indexPath.row].id))
            //loading.startAnimating()
            //loading.isHidden=false
           // hobbyContent.isHidden=true
          /*  guard let url = URL(string: "http://jhapp.com.au/displayHobbyWithTag.php") else{return}
            var request=URLRequest(url: url)
            request.httpMethod = "POST"
          // let para="tag2="+selectedSubnav[indexPath.row];
           // request.httpBody=para.data(using: String.Encoding.utf8);
            let session=URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if let data=data{
                    do {
                        let printString=String(data: data, encoding: String.Encoding.utf8)
                        print(printString)
                        self.hobbyArticles=try JSONDecoder().decode([HobbyArticle].self, from: data)
                        
                    } catch{
                        print(error);
                    }
                    
                }
                DispatchQueue.main.async {
                    self.loading.stopAnimating();
                    self.loading.isHidden=true
                    self.hobbyContent.reloadData();
                    self.hobbyContent.isHidden=false;
                    if(self.hobbyArticles.count>0){
                        self.hobbyContent.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableViewScrollPosition.top, animated: true)
                    }
                    let cell = self.nameView.cellForItem(at: indexPath) as! HobbyNameCell
                    //cell.isSelected=true
                    for index in self.nameView.indexPathsForVisibleItems{
                        let allCellItem=self.nameView.cellForItem(at: index) as!HobbyNameCell
                        allCellItem.hobbyNameLable.textColor=UIColor.black
                        if((allCellItem.layer.sublayers?.count)!>1){
                            allCellItem.layer.sublayers![1].removeFromSuperlayer()
                        }
                    }
                    
                    let border = CALayer()
                    let borderWidth = CGFloat(2.0)
                    border.borderColor = UIColor.red.cgColor
                    border.frame = CGRect(x: cell.frame.size.width*0.3, y: cell.frame.size.height - borderWidth, width:  cell.frame.size.width*0.45, height: cell.frame.size.height)
                    border.borderWidth = borderWidth
                    cell.hobbyNameLable.textColor=UIColor.red
                    cell.layer.addSublayer(border)
                    
                    UIView.animate(withDuration: 0.3, animations: {
                        self.view.layoutIfNeeded()
                        
                    })
                }
                }.resume();
            UIView.animate(withDuration: 0.3) {
                self.dropdownMenu.isHidden=true;
            }*/
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showComment"){
            if let destination=segue.destination as? CommentController{
                destination.hobby=selectedHobby
            }
        }
        /*if(segue.identifier == "showHobbyArticle"){
            if let destination=segue.destination as? HobbyArticleController{
                destination.article=hobbyArticles[(hobbyContent.indexPathForSelectedRow?.row)!]
            }
        }*/
        if(segue.identifier == "showContact"){
            if let destination=segue.destination as? ContactViewController{
                destination.another_user_id = selectedHobby?.user_id
                
            }
        }
        
    }
    
    var hobbyArticles=[HobbyArticle]();
    let iconNav=["专题","服务","活动","达人"]
    //var collections:[Collection]=Array<Collection>();
    var cates:[Cate]=Array<Cate>();

    var ifHide=false;
    var initialAdTop:CGFloat?;
    var iconNavAlreadyTapped = false
    var ifLoadFromDropDown=false;
    var dropDownIndexPath:IndexPath?
    var currentCateId="";
    var refresher:UIRefreshControl!
    
    override func viewDidAppear(_ animated: Bool) {
        iconNavAlreadyTapped = false
    }

    @IBOutlet var loading: UIActivityIndicatorView!
    @IBOutlet weak var imgHeight: NSLayoutConstraint!
    @IBOutlet weak var iconNavHeight: NSLayoutConstraint!
    @IBOutlet weak var iconNavTop: NSLayoutConstraint!
    @IBOutlet weak var adTop: NSLayoutConstraint!
    @IBOutlet weak var hobbyContent: UITableView!    
    @IBOutlet weak var iconNavView: UICollectionView!
    @IBOutlet weak var nameView: UICollectionView!
    @IBOutlet weak var ad: UIImageView!
   
   
    @IBAction func dropDown(_ sender: Any) {
        self.dropdownMenu.isHidden = !self.dropdownMenu.isHidden
    }
    @IBOutlet var segmentedView: CustomizeSegmentedControl!
    
    @IBOutlet var dropDownMenuHeight: NSLayoutConstraint!
    @IBOutlet var dropdownMenu: UITableView!
    @IBOutlet var dropButton: UIButton!
    var selectedHobby:HobbyArticle?
    @IBAction func reloadSubview(_ sender: CustomizeSegmentedControl) {
        for index in self.nameView.indexPathsForVisibleItems{
            let allCellItem=self.nameView.cellForItem(at: index) as!HobbyNameCell
            allCellItem.hobbyNameLable.textColor=UIColor.black
            if((allCellItem.layer.sublayers?.count)!>1){
                allCellItem.layer.sublayers![1].removeFromSuperlayer()
            }
        }
        let Collection_id=String(Globals.collections[sender.selectedValue].id) ;
        cates=Globals.getCateByCollectionID(collection_id: Collection_id);
        nameView.reloadData()
        dropdownMenu.reloadData()
        self.dropDownMenuHeight.constant = CGFloat(45*self.cates.count)
    }
    
    @IBAction func GotoHobbyWrite(_ sender: Any) {
        if(UserInfo.token != ""){
            let viewChange=self.storyboard?.instantiateViewController(withIdentifier: "uploadHobby");
            self.show(viewChange!, sender: self) //会有back符号
            //self.present(viewChange!, animated:true, completion:nil) 会没有back符号
        }
        else{
            let viewChange=self.storyboard?.instantiateViewController(withIdentifier: "login");
            self.show(viewChange!, sender: self)
        }
    }

   
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y > 50){
            if(self.ifHide==false){
                self.adTop.constant = (self.iconNavTop.constant+self.iconNavHeight.constant+self.imgHeight.constant) * (-1)
                UIView.animate(withDuration: 0.3, animations: {
                     self.view.layoutIfNeeded()
                    
                })
            }
            self.ifHide=true
        }
        if(scrollView.contentOffset.y < 50){
            if(self.ifHide==true){
                self.adTop.constant = self.initialAdTop!
                UIView.animate(withDuration: 0.3, animations: {
                     self.view.layoutIfNeeded()
                    
                })
                
                self.ifHide=false
            }
        }
    }
    
    func loadCollection(){
        guard let url=URL(string: "https://app.meljianghu.com/api/collection/all") else{return}
        var request=URLRequest(url: url)
        request.httpMethod="GET"
        let session=URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let data=data{
                do {
                   // let printString=String(data: data, encoding: String.Encoding.utf8)
                    Globals.collections=try JSONDecoder().decode([Collection].self, from: data)
                    var buttonString = ""
                    for collection in Globals.collections{
                        buttonString=buttonString + collection.name + "   ,"
                    }
                    DispatchQueue.main.async {
                        self.segmentedView.ButtonTitleString=buttonString
                        self.segmentedView.updateView()
                    }
                    //self.hobbyArticles=try JSONDecoder().decode([HobbyArticle].self, from: data)
                } catch{
                    print(error);
                }
                
            }
           
            }.resume();
    }
    
    func loadAllCate(){
        guard let url=URL(string: "https://app.meljianghu.com/api/category/all") else{return}
        var request=URLRequest(url: url)
        request.httpMethod="GET"
        let session=URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let data=data{
                do {
                    Globals.categories=try JSONDecoder().decode([Cate].self,from: data)
                    self.cates=Globals.getCateByCollectionID(collection_id: "1")
                    DispatchQueue.main.async {
                        self.nameView.reloadData();
                        self.dropdownMenu.reloadData()
                        self.dropDownMenuHeight.constant = CGFloat(45*self.cates.count)
                    }
                } catch{
                    print(error);
                }
                
            }
            }.resume();
    }
    @objc func reloadHobbies(){
        loadHobbies(cate_id: currentCateId)
        hobbyContent.reloadData()
        refresher.endRefreshing();
    }
    
    func loadHobbies(cate_id:String){
        guard let url=URL(string: "https://app.meljianghu.com/api/hobby/get_by_cate/"+cate_id) else{return}
        var request=URLRequest(url: url)
        request.httpMethod="GET"
        let session=URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let data=data{
                do {
                    let printString=String(data: data, encoding: String.Encoding.utf8)
                  //print(printString)
                    self.hobbyArticles=try JSONDecoder().decode([HobbyArticle].self, from: data)
                } catch{
                    print(error);
                }
                
            }
            DispatchQueue.main.async {
                self.loading.stopAnimating()
                self.loading.isHidden=true
                self.hobbyContent.isHidden=false
                self.hobbyContent.reloadData();
                if(self.ifLoadFromDropDown){
                    let cell=self.nameView.cellForItem(at: self.dropDownIndexPath!) as!HobbyNameCell
                    
                    for index in self.nameView.indexPathsForVisibleItems{
                        let allCellItem=self.nameView.cellForItem(at: index) as!HobbyNameCell
                        allCellItem.hobbyNameLable.textColor=UIColor.black
                        if((allCellItem.layer.sublayers?.count)!>1){
                            allCellItem.layer.sublayers![1].removeFromSuperlayer()
                        }
                    }
                    let border = CALayer()
                    let borderWidth = CGFloat(2.0)
                    border.borderColor = UIColor.red.cgColor
                    border.frame = CGRect(x: cell.frame.size.width*0.3, y: cell.frame.size.height - borderWidth, width:  cell.frame.size.width*0.45, height: cell.frame.size.height)
                    border.borderWidth = borderWidth
                    cell.layer.addSublayer(border)
                    cell.hobbyNameLable.textColor=UIColor.red
                    self.ifLoadFromDropDown=false
                }
            }
            }.resume();
    }
    
    
   
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        /*
        loading.startAnimating()
        loading.isHidden=false
        hobbyContent.isHidden=true
        
        
        loadCollection();
        loadAllCate();
        loadHobbies(cate_id:"1");
        
        for index in self.nameView.indexPathsForVisibleItems{
            let allCellItem=self.nameView.cellForItem(at: index) as!HobbyNameCell
            allCellItem.hobbyNameLable.textColor=UIColor.black
            if((allCellItem.layer.sublayers?.count)!>1){
                allCellItem.layer.sublayers![1].removeFromSuperlayer()
            }
        }
        segmentedView.initialization();
   */
        
    }
    
    override func viewDidLoad() {
        
        
        nameView.dataSource = self;
        nameView.delegate=self;
        nameView.layer.zPosition=10;
        hobbyContent.delegate=self;
        hobbyContent.dataSource=self;
        iconNavView.dataSource=self;
        iconNavView.delegate=self;
        dropdownMenu.dataSource=self
        dropdownMenu.delegate=self
        dropdownMenu.separatorStyle = .none
        initialAdTop=adTop.constant
        super.viewDidLoad()
        refresher=UIRefreshControl();
        refresher.addTarget(self, action: #selector(HobbyController.reloadHobbies), for: UIControlEvents.valueChanged)
        hobbyContent.refreshControl=refresher
        hobbyContent.estimatedRowHeight=500
        hobbyContent.rowHeight = UITableViewAutomaticDimension
        hobbyContent.separatorStyle = .none
        //dropDownMenuHeight.constant=CGFloat(45*selectedSubnav.count)
        loading.startAnimating()
        loading.isHidden=false
        hobbyContent.isHidden=true
        loadCollection();
        loadAllCate();
        loadHobbies(cate_id:"1");
        for index in self.nameView.indexPathsForVisibleItems{
            let allCellItem=self.nameView.cellForItem(at: index) as!HobbyNameCell
            allCellItem.hobbyNameLable.textColor=UIColor.black
            if((allCellItem.layer.sublayers?.count)!>1){
                allCellItem.layer.sublayers![1].removeFromSuperlayer()
            }
        }
        segmentedView.initialization();
        
    }
}

extension UIImageView {
   
    public func downloadedFrom(url: String){
        let imageCache = NSCache<AnyObject, AnyObject>();
        var currentUrl: String? //Get a hold of the latest request url
        currentUrl = url
        if(imageCache.object(forKey: url as AnyObject) != nil){
            self.image = imageCache.object(forKey: url as AnyObject) as? UIImage
        }else{
            
            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
            let task = session.dataTask(with: NSURL(string: url)! as URL, completionHandler: { (data, response, error) -> Void in
                if error == nil {
                    
                  DispatchQueue.main.async{ () -> Void in
                        if let downloadedImage = UIImage(data: data!) {
                            if (url == currentUrl) {//Only cache and set the image view when the downloaded image is the one from last request
                                imageCache.setObject(downloadedImage, forKey: url as AnyObject)
                                self.image = downloadedImage
                            }
                        }
                    }
                }
                else {
                    print(error)
                }
            })
            task.resume()
        }
        
    }
   /* func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image

            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }*/
}
