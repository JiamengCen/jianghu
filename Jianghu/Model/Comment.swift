//
//  Comment.swift
//  Jianghu
//
//  Created by Jiameng Cen on 24/7/18.
//  Copyright © 2018 InternationalTradeMaster. All rights reserved.
//

import Foundation

struct Comment:Codable{
    let content:String;
    let id :Int;
    let user_id:String;
    let hobby_id:String;
    let target_user:String;
    let user_name:String;
    let target_user_name:String
    let created_at:String
}

