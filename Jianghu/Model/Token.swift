//
//  Token.swift
//  Jianghu
//
//  Created by Jiameng Cen on 26/7/18.
//  Copyright © 2018 InternationalTradeMaster. All rights reserved.
//

import Foundation

struct Token:Codable{
    var token_type: String
    var expires_in: Int
    var access_token:String
    var refresh_token:String
}
