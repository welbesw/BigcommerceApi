//
//  BigcommerceOrderProductOption.swift
//  Pods
//
//  Created by William Welbes on 4/19/16.
//
//

import Foundation

public class BigcommerceOrderProductOption: NSObject {
    
    public var id : NSNumber?
    
    public var displayValue:String = ""
    public var orderProductId:NSNumber?
    public var optionId:NSNumber?
    public var name:String = ""
    public var type:String?
    public var value:String = ""
    public var productOptionId:NSNumber?
    public var displayName:String = ""
    public var displayStyle:String?
    
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
