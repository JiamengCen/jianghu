//
//  Globals.swift
//  Jianghu
//
//  Created by Jiameng Cen on 27/7/18.
//  Copyright © 2018 InternationalTradeMaster. All rights reserved.
//

import Foundation

struct Globals {
     public static var collections=Array<Collection>()
     public static var categories=Array<Cate>();
    
    public static func getCateByCollectionID(collection_id: String)->[Cate]{
        var cates=Array<Cate>();
        for cate in self.categories{
            if cate.collection_id == collection_id{
                cates.append(cate);
            }
        }
        return cates
    }
}
