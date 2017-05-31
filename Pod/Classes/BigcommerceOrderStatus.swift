//
//  BigcommerceOrderStatus.swift
//  Pods
//
//  Created by William Welbes on 8/11/15.
//
//

import Foundation

open class BigcommerceOrderStatus: NSObject {
    open var id: Int = 0
    open var name: String = ""
    open var order: Int = 0
    
    public init(jsonDictionary:NSDictionary) {
        //Load the JSON dictionary into the order object
        
        if let idString = jsonDictionary["id"] as? String {
            if let id = Int(idString) {
                self.id = id
            }
        } else if let id = jsonDictionary["id"] as? Int {
            self.id = id
        }
        
        if let name = jsonDictionary["name"] as? String {
            self.name = name
        }
        
        if let orderString = jsonDictionary["order"] as? String {
            if let order = Int(orderString) {
                self.order = order
            }
        }
    }
}
