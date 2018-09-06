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
    let id :Int;
    let image_url:String;
    let collection_id:String;
    let cate_id:String;
    let user_id:String;
    let comments:[Comment];
    let created_at:String;
    let user_name: String?;
    let collection_name:String?
    let cate_name:String?
    let likes:Int
}
