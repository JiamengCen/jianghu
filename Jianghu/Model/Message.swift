//
//  Message.swift
//  Jianghu
//
//  Created by Jiameng Cen on 30/7/18.
//  Copyright © 2018 InternationalTradeMaster. All rights reserved.
//

import Foundation
struct Message:Encodable {
    let message_sender_id:String
    let messageText:String
}
