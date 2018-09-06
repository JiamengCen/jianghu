//
//  HobbyArticleController.swift
//  Jianghu
//
//  Created by WANG, Yanqi on 2018/4/26.
//  Copyright © 2018年 InternationalTradeMaster. All rights reserved.
//

import UIKit

class HobbyArticleController: UIViewController {


    @IBOutlet weak var img6: UIImageView!
    @IBOutlet weak var img5: UIImageView!
    @IBOutlet weak var img4: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var author: UILabel!
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    
    var imgs=[UIImageView]();
    var article:HobbyArticle?
    override func viewDidLoad() {
        super.viewDidLoad()
       // articleTitle.text=article?.title
       // content.text=article?.content;
        imgs.append(img1);
        imgs.append(img2);
        imgs.append(img3);
        imgs.append(img4);
        imgs.append(img5);
        imgs.append(img6);
        
        content.text=article?.content;
       // author.text=article?.user_name;
        //let defualtLink="http://jianghu.000webhostapp.com/"
        //let addLink=article?.img
       // let link="http://jhapp.com.au/"+(article?.img)!
        for img in imgs{
           /* if(imgs.index(of: img)!<Int((article?.img_num)!)!){
                let pictureTap = UITapGestureRecognizer(target: self, action: #selector(HobbyArticleController.imageTapped(_:)))
                img.isUserInteractionEnabled=true;
                img.addGestureRecognizer(pictureTap);
                img.downloadedFrom(link: link+"_"+String(imgs.index(of: img)!))
                img.contentMode = .scaleAspectFill
            }*/
        }
        
        
       // img.downloadedFrom(link: defualtLink+addLink!);
       // img.contentMode = .scaleAspectFill;

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



