//
//  BigcommerceProductSku.swift
//  Pods
//
//  Created by William Welbes on 4/18/16.
//
//

import Foundation

open class BigcommerceProductSku: NSObject {
    
    open var productSkuId:NSNumber?
    open var productId:NSNumber?
    
    open var sku:String = ""
    open var upc:String = ""
    open var price:NSNumber?
    open var weight:NSNumber?
    
    //TODO: product options
    
    open var costPrice:NSNumber?
    open var imageFile:String?
    open var adjustedPrice:NSNumber?
    open var adjustedWeight:NSNumber?
    open var inventoryLevel:NSNumber?
    open var binPickingNumber:String?
    open var isPurchasingDisabled:Bool = false
    open var inventoryWarningLevel:NSNumber?
    open var purchasingDisabledMessage:String?
    
    open var dateCreated:Date?
    open var dateModified:Date?
    
    public init(jsonDictionary: NSDictionary, currencyLocale: Locale?) {
        //Load the JSON dictionary into the object
        
        //Float values are returned as quote enclosed strings in the JSON from the API
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        numberFormatter.locale = currencyLocale
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, d MMM yyyy HH:mm:ss zzz"
        
        if let id = jsonDictionary["id"] as? NSNumber {
            self.productSkuId = id
        }
        
        if let id = jsonDictionary["product_id"] as? NSNumber {
            self.productId = id
        }
        
        if let stringValue = jsonDictionary["sku"] as? String {
            self.sku = stringValue
        }
        
        if let stringValue = jsonDictionary["price"] as? String {
            if let numberValue = numberFormatter.number(from: stringValue) {
                price = numberValue
            }
        }
        
        if let stringValue = jsonDictionary["cost_price"] as? String {
            if let numberValue = numberFormatter.number(from: stringValue) {
                if numberValue.floatValue > 0.0 {
                    costPrice = numberValue
                }
            }
        }
        
        if let stringValue = jsonDictionary["adjusted_price"] as? String {
            if let numberValue = numberFormatter.number(from: stringValue) {
                if numberValue.floatValue > 0.0 {
                    adjustedPrice = numberValue
                }
            }
        }
        
        if let stringValue = jsonDictionary["adjusted_weight"] as? String {
            let formatter = NumberFormatter()
            if let numberValue = formatter.number(from: stringValue) {
                if numberValue.floatValue > 0.0 {
                    adjustedWeight = numberValue
                }
            }
        }
        
        if let stringValue = jsonDictionary["image_file"] as? String {
            self.imageFile = stringValue
        }
        
        if let stringValue = jsonDictionary["bin_picking_number"] as? String {
            self.binPickingNumber = stringValue
        }
        
        if let numberValue = jsonDictionary["inventory_level"] as? NSNumber {
            self.inventoryLevel = numberValue
        }
        
        if let numberValue = jsonDictionary["inventory_warning_level"] as? NSNumber {
            self.inventoryWarningLevel = numberValue
        }
        
        if let boolValue = (jsonDictionary["is_purchasing_disabled"] as? NSNumber)?.boolValue {
            self.isPurchasingDisabled = boolValue
        }
        
        if let stringValue = jsonDictionary["purchasing_disabled_message"] as? String {
            self.purchasingDisabledMessage = stringValue
        }
        
        
        if let dateString = jsonDictionary["date_created"] as? String {
            if let date = dateFormatter.date(from: dateString) {
                dateCreated = date
            }
        }
        
        if let dateString = jsonDictionary["date_modified"] as? String {
            if let date = dateFormatter.date(from: dateString) {
                dateModified = date
            }
        }
    }
}
