//
//  HobbyArticle.swift
//  Jianghu
//
//  Created by WANG, Yanqi on 2018/4/25.
//  Copyright © 2018年 InternationalTradeMaster. All rights reserved.
//

import Foundation

struct HobbyArticle:Decodable {
    let content:String;
    let id :String;
    let img:String;
    let tag1:String;
    let tag2:String;
    let title:String;
    let user_id:String;
    let user_name:String;
    let img_num:String?
    
}
