//
//  BigcommerceOrderShipmentItem.swift
//  Pods
//
//  Created by William Welbes on 10/19/15.
//
//

import Foundation

public class BigcommerceOrderShipmentItem: NSObject {
    public var orderProductId: NSNumber?
    public var productId:NSNumber?
    public var quantity:NSNumber?
    
    
    public init(jsonDictionary:NSDictionary) {
        //Load the JSON dictionary into the object
        
        
        if let id = jsonDictionary["product_id"] as? NSNumber {
            self.productId = id
        }
        
        if let id = jsonDictionary["order_product_id"] as? NSNumber {
            self.orderProductId = id
        }
        
        if let id = jsonDictionary["quantity"] as? NSNumber {
            self.quantity = id
        }
        
    }
}