//
//  LoginData.swift
//  Jianghu
//
//  Created by Jiameng Cen on 26/7/18.
//  Copyright © 2018 InternationalTradeMaster. All rights reserved.
//

import Foundation


struct LoginData:Codable{
    var client_id: Int
    var client_secret: String
    var grant_type: String
    var scope:String
    var username:String
    var password:String
}
