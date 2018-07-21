//
//  Activity.swift
//  Jianghu
//
//  Created by WANG, Yanqi on 2018/4/26.
//  Copyright © 2018年 InternationalTradeMaster. All rights reserved.
//

import Foundation

struct Activity:Decodable {
    let content:String;
    let id :String;
    let title:String;
    let user_id:String;
    let user_name:String;
    let times:String;
    let place:String;
    let phone:String;
    let category:String;
    let img:String;
    let if_big:String;
}
