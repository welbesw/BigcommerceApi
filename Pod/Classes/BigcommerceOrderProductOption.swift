//
//  BigcommerceOrderProductOption.swift
//  Pods
//
//  Created by William Welbes on 4/19/16.
//
//

import Foundation

open class BigcommerceOrderProductOption: NSObject {
    
    open var id : NSNumber?
    
    open var displayValue:String = ""
    open var orderProductId:NSNumber?
    open var optionId:NSNumber?
    open var name:String = ""
    open var type:String?
    open var value:String = ""
    open var productOptionId:NSNumber?
    open var displayName:String = ""
    open var displayStyle:String?
    
    public init(jsonDictionary:NSDictionary) {
        //Load the JSON dictionary into the order object
        
        if let numberValue = jsonDictionary["id"] as? NSNumber {
            id = numberValue
        }
        
        if let stringValue = jsonDictionary["display_value"] as? String {
            displayValue = stringValue
        }
        
        if let numberValue = jsonDictionary["order_product_id"] as? NSNumber {
            orderProductId = numberValue
        }
        
        if let numberValue = jsonDictionary["option_id"] as? NSNumber {
            optionId = numberValue
        }
        
        if let stringValue = jsonDictionary["name"] as? String {
            name = stringValue
        }
        
        if let stringValue = jsonDictionary["type"] as? String {
            type = stringValue
        }
        
        if let stringValue = jsonDictionary["value"] as? String {
            value = stringValue
        }
        
        if let numberValue = jsonDictionary["product_option_id"] as? NSNumber {
            productOptionId = numberValue
        }

        if let stringValue = jsonDictionary["display_name"] as? String {
            displayName = stringValue
        }
        
        if let stringValue = jsonDictionary["display_style"] as? String {
            displayStyle = stringValue
        }
    }
}
