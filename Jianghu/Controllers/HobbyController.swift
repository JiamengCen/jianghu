
import UIKit

class HobbyController:UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hobbyArticles.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var imgs=[UIImageView]();
        let cell = hobbyContent.dequeueReusableCell(withIdentifier: "hobbyTableCell") as! HobbyTableViewCell
        imgs.append(cell.img1)
        imgs.append(cell.img2)
        imgs.append(cell.img3)
        imgs.append(cell.img4)
        imgs.append(cell.img5)
        imgs.append(cell.img6)
        cell.user.text = hobbyArticles[indexPath.row].user_name
        cell.content.text=hobbyArticles[indexPath.row].content
        cell.tag2.text=hobbyArticles[indexPath.row].tag2
        cell.tag2.layer.cornerRadius=cell.frame.height/10;
        let link="http://jhapp.com.au/"+hobbyArticles[indexPath.row].img
        let imgCount=Int(hobbyArticles[indexPath.row].img_num!);
        let totalImageView=6;
        if(imgCount!<4){
            cell.imgStack2.isHidden=true;
            cell.totalStackHeight.constant=90
            
        }
        else{
            cell.imgStack2.isHidden=false;
            cell.totalStackHeight.constant=190
        }
        var i=0;
        while(i<totalImageView){
            if(i<imgCount!){
                imgs[i].downloadedFrom(link: link+"_"+String(i))
                imgs[i].contentMode = .scaleAspectFill
            }
            else{
                imgs[i].image=nil
                
            }
            i=i+1
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView==self.nameView{
            return selectedSubnav.count
        }
        else {
            return iconNav.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView==self.nameView{
            let hobbyNamesCell=nameView.dequeueReusableCell(withReuseIdentifier: "hobbyNames", for: indexPath) as! HobbyNameCell
            //hobbyNamesCell.hobbyNameLable.font=UIFont(name: "STXingkai", size: 16)
            hobbyNamesCell.hobbyNameLable.text=selectedSubnav[indexPath.row]
         //   hobbyNamesCell.hobbyNameLable.textColor=UIColor.black;
            return hobbyNamesCell
        }
        else {
            let iconNavCell=iconNavView.dequeueReusableCell(withReuseIdentifier: "iconNavCell", for: indexPath) as!HobbyIconNavCell
            iconNavCell.text.text=iconNav[indexPath.row]
            iconNavCell.img.image=UIImage(named: "navIcon"+String(indexPath.row))
            return iconNavCell
            
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView,didSelectItemAt indexPath: IndexPath){
        if collectionView==self.nameView{
            
            guard let url=URL(string: "http://jhapp.com.au/displayHobbyWithTag.php") else{return}
            var request=URLRequest(url: url)
            request.httpMethod="POST"
            let para="tag2="+selectedSubnav[indexPath.row];
            request.httpBody=para.data(using: String.Encoding.utf8);
            let session=URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if let data=data{
                    do {
                        self.hobbyArticles=try JSONDecoder().decode([HobbyArticle].self, from: data)
                        
                    } catch{
                        print(error);
                    }
                    
                }
                DispatchQueue.main.async {
                    self.hobbyContent.reloadData();
                }
            }.resume();
        }
        else{
            if iconNavAlreadyTapped==true {
                return
                
            }
            else{
                if(indexPath.row==1){
                    performSegue(withIdentifier: "showTopic", sender: self)
                }
                if(indexPath.row==2){
                    performSegue(withIdentifier: "showMerchant", sender: self)
                }
                if(indexPath.row==3){
                    performSegue(withIdentifier: "showActivity", sender: self)
                }
                iconNavAlreadyTapped=true
            }
           
            
        }
       
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier:"showHobbyArticle", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination=segue.destination as? HobbyArticleController{
            destination.article=hobbyArticles[(hobbyContent.indexPathForSelectedRow?.row)!]
        }
    }
    
    var hobbyArticles=[HobbyArticle]();
    let iconNav=["动态","专题","服务","活动"]
    let play=["球类","桌游","演唱","电竞","唱歌","摄影","游艇","酒吧"]
    let live=["美食","运动","健身","亲子","音乐","旅游","汽车","文化"]
    let campus=["课程","大学","专业","雅思","PTE"]
    let commercial=["法律","金融","科技","电商","设计","地产","政治"]
    var subNav:[[String]]=Array<Array<String>>()
    var selectedSubnav:[String]=Array<String>();

    var ifHide=false;
    var initialAdTop:CGFloat?;
    var iconNavAlreadyTapped = false
    
    override func viewDidAppear(_ animated: Bool) {
        iconNavAlreadyTapped = false
    }

    @IBOutlet weak var imgHeight: NSLayoutConstraint!
    @IBOutlet weak var iconNavHeight: NSLayoutConstraint!
    @IBOutlet weak var iconNavTop: NSLayoutConstraint!
    @IBOutlet weak var nameViewHeight: NSLayoutConstraint!
    @IBOutlet weak var adTop: NSLayoutConstraint!
    @IBOutlet weak var hobbyContent: UITableView!    
    @IBOutlet weak var iconNavView: UICollectionView!
    @IBOutlet weak var nameView: UICollectionView!
    @IBOutlet weak var ad: UIImageView!
   
    @IBAction func reloadSubview(_ sender: CustomizeSegmentedControl) {
        selectedSubnav=subNav[sender.selectedValue]
        self.nameView.reloadData();
    }
    
    @IBAction func GotoHobbyWrite(_ sender: Any) {
        if(UserInfo.ifLogin){
            let viewChange=self.storyboard?.instantiateViewController(withIdentifier: "uploadHobby");
            self.show(viewChange!, sender: self)
            //self.present(viewChange!, animated:true, completion:nil)
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
    
   
    override func viewWillAppear(_ animated: Bool) {
        guard let url=URL(string: "http://jhapp.com.au/displayAllHobby.php") else{return}
        var request=URLRequest(url: url)
        request.httpMethod="POST"
        // request.httpBody=parameter.data(using: String.Encoding.utf8);
        let session=URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let data=data{
                do {
                    self.hobbyArticles=try JSONDecoder().decode([HobbyArticle].self, from: data)
                    
                } catch{
                    print(error);
                }
                
            }
            DispatchQueue.main.async {
                self.hobbyContent.reloadData();
            }
        }.resume();
    }
    
    override func viewDidLoad() {
        
        
        nameView.dataSource = self;
        nameView.delegate=self;
        nameView.layer.zPosition=10;
        hobbyContent.delegate=self;
        hobbyContent.dataSource=self;
        iconNavView.dataSource=self;
        iconNavView.delegate=self;
        initialAdTop=adTop.constant
        subNav.removeAll();
        subNav.append(play);
        subNav.append(live);
        subNav.append(campus);
        subNav.append(commercial);
        selectedSubnav=subNav[0];
        
        
       /* guard let url=URL(string: "http://jhapp.com.au/displayAllHobby.php") else{return}
        var request=URLRequest(url: url)
        request.httpMethod="POST"
       // request.httpBody=parameter.data(using: String.Encoding.utf8);
        let session=URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let data=data{
                do {
                     self.hobbyArticles=try JSONDecoder().decode([HobbyArticle].self, from: data)

                } catch{
                    print(error);
                }
                
            }
            DispatchQueue.main.async {
                self.hobbyContent.reloadData();
            }
        }.resume();*/
        
        
        super.viewDidLoad()
        hobbyContent.estimatedRowHeight=500
        hobbyContent.rowHeight = UITableViewAutomaticDimension
    }
}


extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
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
    }
}
