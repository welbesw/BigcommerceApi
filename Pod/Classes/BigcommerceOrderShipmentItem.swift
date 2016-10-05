//
//  BigcommerceOrderShipmentItem.swift
//  Pods
//
//  Created by William Welbes on 10/19/15.
//
//

import Foundation

open class BigcommerceOrderShipmentItem: NSObject {
    open var orderProductId: NSNumber?
    open var productId:NSNumber?
    open var quantity:NSNumber?
    
    
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
