//
//  UserInfomation.swift
//  Jianghu
//
//  Created by Jiameng Cen on 27/7/18.
//  Copyright © 2018 InternationalTradeMaster. All rights reserved.
//

import Foundation

struct UserInformation:Codable{
    var id: Int
    var name: String
    var email:String
    var phone:String
    var points:String
    var money:String
    var chatkit_id:String
    var created_at: String
}
