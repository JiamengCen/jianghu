//
//  Register.swift
//  Jianghu
//
//  Created by Jiameng Cen on 24/7/18.
//  Copyright © 2018 InternationalTradeMaster. All rights reserved.
//

import Foundation

struct Register:Codable{
    let name:String;
    let email: String;
    let phone :String;
    let password: String;
    let password_confirmation: String;
}
