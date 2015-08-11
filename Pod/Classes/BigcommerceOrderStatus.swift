//
//  BigcommerceOrderStatus.swift
//  Pods
//
//  Created by William Welbes on 8/11/15.
//
//

import Foundation

public class BigcommerceOrderStatus: NSObject {
    public var id: NSNumber = 0
    public var name: String = ""
    public var order: NSNumber = 0
    
    public init(jsonDictionary:NSDictionary) {
        //Load the JSON dictionary into the order object
        
        if let id = jsonDictionary["id"] as? NSNumber {
            self.id = id
        }
        
        if let name = jsonDictionary["name"] as? String {
            self.name = name
        }
        
        if let order = jsonDictionary["order"] as? NSNumber {
            self.order = order
        }
    }
}