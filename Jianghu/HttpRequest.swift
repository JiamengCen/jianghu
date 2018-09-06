//
//  HttpRequest.swift
//  Jianghu
//
//  Created by WANG, Yanqi on 2018/4/16.
//  Copyright © 2018年 InternationalTradeMaster. All rights reserved.
//

import Foundation

class HttpRequest {
    var result:Data;
    var done:Bool;
    
    init(){
        self.result=Data();
        done=false;
    }
    func GET(url:String) {
        guard let url = URL(string:url) else {
            return
        }
        let session=URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let response=response{
                print(response);
            }
            if let data=data{
                self.result=data
                print(data);
                do {
                    let json=try JSONSerialization.jsonObject(with: data, options:[])
                    print(json);
                } catch{
                    print(error);
                }
                self.done=true;
            }
            }.resume();
    }
    
     func POST(url:String,parameter:String){
        guard let url=URL(string: url) else{return}
        var request=URLRequest(url: url)
        request.httpMethod="POST"
        request.httpBody=parameter.data(using: String.Encoding.utf8);
        let session=URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            print(response);
            if let data=data{
                self.result=data
                let printString=String(data: data, encoding: String.Encoding.utf8)
                print(printString)
                do {
                    
                   let json=try JSONSerialization.jsonObject(with: data, options:[])
                   print(json)
                } catch{
                    print(error);
                }
                self.done=true;
                
            }
        }.resume();
        
    }
}
