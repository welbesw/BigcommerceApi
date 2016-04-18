//
//  BigcommerceProductSku.swift
//  Pods
//
//  Created by William Welbes on 4/18/16.
//
//

import Foundation

public class BigcommerceProductSku: NSObject {
    
    public var productSkuId:NSNumber?
    public var productId:NSNumber?
    
    public var sku:String = ""
    public var upc:String = ""
    public var price:NSNumber?
    public var weight:NSNumber?
    
    //TODO: product options
    
    public var costPrice:NSNumber?
    public var imageFile:String?
    public var adjustedPrice:NSNumber?
    public var adjustedWeifht:NSNumber?
    public var inventoryLevel:NSNumber?
    public var binPickingNumber:String?
    public var isPurchasingDisabled:Bool = false
    public var inventoryWarningLevel:NSNumber?
    public var purchasingDisabledMessage:String?
    
    public var dateCreated:NSDate?
    public var dateModified:NSDate?
    
    public init(jsonDictionary:NSDictionary) {
        //Load the JSON dictionary into the object
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE, d MMM yyyy HH:mm:ss zzz"
        
        if let id = jsonDictionary["id"] as? NSNumber {
            self.productSkuId = id
        }
        
        if let id = jsonDictionary["product_id"] as? NSNumber {
            self.productId = id
        }
        
        
        
        if let dateString = jsonDictionary["date_created"] as? String {
            if let date = dateFormatter.dateFromString(dateString) {
                dateCreated = date
            }
        }
        
        if let dateString = jsonDictionary["date_modified"] as? String {
            if let date = dateFormatter.dateFromString(dateString) {
                dateModified = date
            }
        }
    }
}