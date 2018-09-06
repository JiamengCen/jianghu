//
//  Activity.swift
//  Jianghu
//
//  Created by WANG, Yanqi on 2018/4/26.
//  Copyright © 2018年 InternationalTradeMaster. All rights reserved.
//

import Foundation

struct Activity:Codable {
    
    let id :Int;
    let content:String;
    let title:String;
    let user_id:String;
    let user_name:String;
    let collection_id:String;
    let cate_id:String;
    let address:String;
    let start_time:String;
    let end_time:String;
    let img_url_top:String;
    let img_url_bottom:String;
    let created_at:String;
    let updated_at:String;
    let type:String;
    let collection_name:String;
    let cate_name:String;
    let comments:[ActivityComment];
}
