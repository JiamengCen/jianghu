//
//  ActivityUpload.swift
//  Jianghu
//
//  Created by WANG, Yanqi on 2018/7/31.
//  Copyright © 2018年 InternationalTradeMaster. All rights reserved.
//

import Foundation

struct ActivityUpload:Encodable {
    let content:String;
    let title:String;
    let user_id:String;
    let collection_id:String;
    let cate_id:String;
    let address:String;
    let start_time:String;
    let end_time:String;
    let img_url_top:String;
    let img_url_bottom:String;
    let type:String
}
