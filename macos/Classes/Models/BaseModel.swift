//
//  BaseModel.swift
//  flutter_rtmp
//
//  Created by Apple on 2020/6/1.
//

import Foundation

enum RtmpOrientation: Int {
    case Portrait = 0
    case Landspace = 1
}

public class BaseModel:Codable{
    
     class func jsonDecode(json : NSData)->BaseModel{
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(self.self, from: json as Data)
        } catch{
            print("json 解析失败")
            return BaseModel()
        }
    }
    
    public func toJson()->Data{
        let encoder = JSONEncoder()
        var jsonData : Data = Data()
        do {
            jsonData = try encoder.encode(self)
        } catch  {
            print("toJson error")
        }
        return jsonData
    }
}





