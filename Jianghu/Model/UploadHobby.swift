//
//  UploadHobby.swift
//  Jianghu
//
//  Created by WANG, Yanqi on 2018/7/29.
//  Copyright © 2018年 InternationalTradeMaster. All rights reserved.
//

import Foundation

struct UploadHobby:Encodable {
    let content:String;
    let image_url:[String];
    let collection_id:String;
    let cate_id:String;
}
