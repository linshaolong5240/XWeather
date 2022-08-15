//
//  JSONHelper.swift
//  XWeather
//
//  Created by teenloong on 2022/8/1.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation

extension Encodable {
    
    subscript(key: String) -> Any? {
        return dictionary[key]
    }
    
    func toData() -> Data? { return try? JSONEncoder().encode(self) }

    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(self))) as? [String: Any] ?? [:]
    }
        
    func toDictionary() -> [String: Any] {
      let mirror = Mirror(reflecting: self)
      let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label:String?, value:Any) -> (String, Any)? in
        guard let label = label else { return nil }
        return (label, value)
      }).compactMap { $0 })
      return dict
    }
    
    func toDictionary() -> [String: Any]? {
        return (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(self))) as? [String: Any]
    }
    
    func toJSONString(encoding: String.Encoding = .utf8) -> String? {
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }
        return String(data: data, encoding: encoding)
    }
}

extension Data {
    func toModel<T: Decodable>(_ type: T.Type) -> T? { try? JSONDecoder().decode(type, from: self) }
}
