//
//  BigcommerceProduct.swift
//  Pods
//
//  Created by William Welbes on 9/30/15.
//
//

import Foundation

open class BigcommerceProduct: NSObject {
    open var productId: NSNumber?

    open var name:String = ""
    open var type:String = ""
    open var sku:String = ""
    open var productDescription:String = ""
    
    open var availabilityDescription:String = ""
    
    open var price:NSNumber = 0
    open var costPrice:NSNumber?
    open var retailPrice:NSNumber?
    open var salePrice:NSNumber?
    open var calculatedPrice:NSNumber = 0
    
    open var sortOrder:NSNumber = 0
    
    open var isVisiable:NSNumber?
    open var isFeatured:NSNumber?
    
    open var inventoryLevel:NSNumber?
    open var inventoryWarningLevel:NSNumber?
    
    open var weight:NSNumber?
    open var width:NSNumber?
    open var height:NSNumber?
    open var depth:NSNumber?
    
    open var fixedCostShippingPrice:NSNumber = 0
    open var isFreeShipping:NSNumber = false
    
    open var inventoryTracking:String = ""
    open var totalSold:NSNumber?
    
    open var dateCreated:Date?
    open var dateModified:Date?
    
    open var condition:String = ""
    
    open var imageThumbnailUrl:String?
    open var availability:String = ""
    
    public init(jsonDictionary:NSDictionary, currencyCode:String) {
        //Load the JSON dictionary into the order object
        
        //Float values are returned as quote enclosed strings in the JSON from the API
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        
        var components:[String : String] = [NSLocale.Key.currencyCode.rawValue : currencyCode]
        if let language = Locale.preferredLanguages.first {
            components.updateValue(language, forKey: NSLocale.Key.languageCode.rawValue)
        }
        let localeIdentifier = Locale.identifier(fromComponents: components)
        let localeForCurrency = Locale(identifier: localeIdentifier);
        numberFormatter.locale = localeForCurrency
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, d MMM yyyy HH:mm:ss zzz"
        
        if let id = jsonDictionary["id"] as? NSNumber {
            self.productId = id
        }
        
        if let stringValue = jsonDictionary["name"] as? String {
            self.name = stringValue
        }
        
        if let stringValue = jsonDictionary["type"] as? String {
            self.type = stringValue
        }
        
        if let stringValue = jsonDictionary["sku"] as? String {
            self.sku = stringValue
        }
        
        if let stringValue = jsonDictionary["description"] as? String {
            self.productDescription = stringValue
        }
        
        if let stringValue = jsonDictionary["availability_description"] as? String {
            self.availabilityDescription = stringValue
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
        
        if let stringValue = jsonDictionary["retail_price"] as? String {
            if let numberValue = numberFormatter.number(from: stringValue) {
                if numberValue.floatValue > 0.0 {
                    retailPrice = numberValue
                }
            }
        }
        
        if let stringValue = jsonDictionary["sale_price"] as? String {
            if let numberValue = numberFormatter.number(from: stringValue) {
                if numberValue.floatValue > 0.0 {
                    salePrice = numberValue
                }
            }
        }
        
        if let stringValue = jsonDictionary["calculated_price"] as? String {
            if let numberValue = numberFormatter.number(from: stringValue) {
                calculatedPrice = numberValue
            }
        }
        
        if let numberValue = jsonDictionary["sort_order"] as? NSNumber {
            self.sortOrder = numberValue
        }
        
        if let numberValue = jsonDictionary["is_visible"] as? NSNumber {
            self.isVisiable = numberValue
        }
        
        if let numberValue = jsonDictionary["is_featured"] as? NSNumber {
            self.isFeatured = numberValue
        }
        
        if let numberValue = jsonDictionary["inventory_level"] as? NSNumber {
            self.inventoryLevel = numberValue
        }
        
        if let numberValue = jsonDictionary["inventory_warning_level"] as? NSNumber {
            self.inventoryWarningLevel = numberValue
        }
        
        if let numberValue = jsonDictionary["weight"] as? NSNumber {
            self.weight = numberValue
        }
        
        if let numberValue = jsonDictionary["width"] as? NSNumber {
            self.width = numberValue
        }
        
        if let numberValue = jsonDictionary["heigh"] as? NSNumber {
            self.height = numberValue
        }
        
        if let numberValue = jsonDictionary["depth"] as? NSNumber {
            self.depth = numberValue
        }

        if let stringValue = jsonDictionary["fixed_cost_shipping_price"] as? String {
            if let numberValue = numberFormatter.number(from: stringValue) {
                fixedCostShippingPrice = numberValue
            }
        }
        
        if let numberValue = jsonDictionary["is_free_shipping"] as? NSNumber {
            self.isFreeShipping = numberValue
        }
        
        if let stringValue = jsonDictionary["inventory_tracking"] as? String {
            self.inventoryTracking = stringValue
        }
        
        if let numberValue = jsonDictionary["total_sold"] as? NSNumber {
            self.totalSold = numberValue
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
        
        if let stringValue = jsonDictionary["condition"] as? String {
            self.condition = stringValue
        }
        
        if let primaryImageItem = jsonDictionary["primary_image"] as? NSDictionary {
            if let stringValue = primaryImageItem["thumbnail_url"] as? String {
                self.imageThumbnailUrl = stringValue
            }
        }
        
        if let stringValue = jsonDictionary["availability"] as? String {
            self.availability = stringValue
        }
    }
    
    open override var description: String {
        //let mirror = Mirror(reflecting: self)
        
        let productIdString = self.productId != nil ? self.productId!.stringValue : ""
        let inventoryLevelString = self.inventoryLevel != nil ? self.inventoryLevel!.stringValue : ""

        var description = "Product \(productIdString) : \(self.name)"
        description += "\nInventory Level: \(inventoryLevelString)"
        
        return description
    }
}
