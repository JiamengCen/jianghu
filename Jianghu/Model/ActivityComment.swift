//
//  ActivityComment.swift
//  Jianghu
//
//  Created by Jiameng Cen on 8/8/18.
//  Copyright © 2018 InternationalTradeMaster. All rights reserved.
//

import Foundation
struct ActivityComment:Codable {
    let content:String;
    let id :Int;
    let user_id:String;
    let activity_id:String;
    let target_user:String;
    let user_name:String;
    let target_user_name:String
    let created_at:String
}
