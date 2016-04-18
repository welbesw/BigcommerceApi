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
    public var adjustedWeight:NSNumber?
    public var inventoryLevel:NSNumber?
    public var binPickingNumber:String?
    public var isPurchasingDisabled:Bool = false
    public var inventoryWarningLevel:NSNumber?
    public var purchasingDisabledMessage:String?
    
    public var dateCreated:NSDate?
    public var dateModified:NSDate?
    
    public init(jsonDictionary:NSDictionary, currencyCode:String) {
        //Load the JSON dictionary into the object
        
        //Float values are returned as quote enclosed strings in the JSON from the API
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        
        var components = [NSLocaleCurrencyCode : currencyCode]
        if let language = NSLocale.preferredLanguages().first {
            components.updateValue(NSLocaleLanguageCode, forKey: language)
        }
        let localeIdentifier = NSLocale.localeIdentifierFromComponents(components)
        let localeForCurrency = NSLocale(localeIdentifier: localeIdentifier);
        numberFormatter.locale = localeForCurrency
        
        let dateFormatter = NSDateFormatter()
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
            if let numberValue = numberFormatter.numberFromString(stringValue) {
                price = numberValue
            }
        }
        
        if let stringValue = jsonDictionary["cost_price"] as? String {
            if let numberValue = numberFormatter.numberFromString(stringValue) {
                if numberValue.floatValue > 0.0 {
                    costPrice = numberValue
                }
            }
        }
        
        if let stringValue = jsonDictionary["adjusted_price"] as? String {
            if let numberValue = numberFormatter.numberFromString(stringValue) {
                if numberValue.floatValue > 0.0 {
                    adjustedPrice = numberValue
                }
            }
        }
        
        if let stringValue = jsonDictionary["adjusted_weight"] as? String {
            let formatter = NSNumberFormatter()
            if let numberValue = formatter.numberFromString(stringValue) {
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