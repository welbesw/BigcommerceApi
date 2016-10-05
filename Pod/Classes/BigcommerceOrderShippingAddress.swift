//
//  BigcommerceOrderShippingAddress.swift
//  Pods
//
//  Created by William Welbes on 8/24/15.
//
//

import Foundation

open class BigcommerceOrderShippingAddress: NSObject {
    
    open var id: NSNumber?
    open var orderId: NSNumber?
    
    open var firstName: String = ""
    open var lastName: String = ""
    open var company: String = ""

    open var street1: String = ""
    open var street2: String = ""
    open var city: String = ""
    open var zip: String = ""
    open var country: String = ""
    open var countryISO2: String = ""
    open var state: String = ""
    open var email: String = ""
    open var phone: String = ""
    
    open var itemsTotal: NSNumber = 0
    open var itemsShipped: NSNumber = 0
    open var shippingMethod: String = ""

    open var baseCost: NSNumber = 0
    open var costExcludingTax: NSNumber = 0
    open var costIncludingTax: NSNumber = 0
    open var costTax: NSNumber = 0
    open var costTaxClassId: NSNumber?

    open var baseHandlingCost: NSNumber = 0
    open var handlingCostExcludingTax: NSNumber = 0
    open var handlingCostIncludingTax: NSNumber = 0
    open var handlingCostTax: NSNumber = 0
    open var handlingCostTaxClassId: NSNumber?
    
    open var shippingZoneId: NSNumber?
    open var shippingZoneName: String = ""
    
    public init(jsonDictionary:NSDictionary, currencyCode:String) {
        //Load the JSON dictionary into the shipping address object
        
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
        
        if let id = jsonDictionary["id"] as? NSNumber {
            self.id = id
        }
        
        if let orderId = jsonDictionary["order_id"] as? NSNumber {
            self.orderId = orderId
        }
        
        if let firstName = jsonDictionary["first_name"] as? String {
            self.firstName = firstName
        }
        
        if let lastName = jsonDictionary["last_name"] as? String {
            self.lastName = lastName
        }
        
        if let stringValue = jsonDictionary["company"] as? String {
            self.company = stringValue
        }
        
        if let stringValue = jsonDictionary["street_1"] as? String {
            self.street1 = stringValue
        }
        
        if let stringValue = jsonDictionary["street_2"] as? String {
            self.street2 = stringValue
        }
        
        if let stringValue = jsonDictionary["city"] as? String {
            self.city = stringValue
        }
        
        if let stringValue = jsonDictionary["zip"] as? String {
            self.zip = stringValue
        }
    
        if let stringValue = jsonDictionary["country"] as? String {
            self.country = stringValue
        }
        
        if let stringValue = jsonDictionary["country_iso2"] as? String {
            self.countryISO2 = stringValue
        }
        
        if let stringValue = jsonDictionary["state"] as? String {
            self.state = stringValue
        }
        
        if let stringValue = jsonDictionary["email"] as? String {
            self.email = stringValue
        }
        
        if let stringValue = jsonDictionary["phone"] as? String {
            self.phone = stringValue
        }
        
        if let numberValue = jsonDictionary["items_total"] as? NSNumber {
            self.itemsTotal = numberValue
        }
        
        if let numberValue = jsonDictionary["items_shipped"] as? NSNumber {
            self.itemsShipped = numberValue
        }
        
        if let stringValue = jsonDictionary["shipping_method"] as? String {
            self.shippingMethod = stringValue
        }

        if let stringValue = jsonDictionary["base_cost"] as? String {
            if let numberValue = numberFormatter.number(from: stringValue) {
                self.baseCost = numberValue
            }
        }
        
        if let stringValue = jsonDictionary["cost_ex_tax"] as? String {
            if let numberValue = numberFormatter.number(from: stringValue) {
                self.costExcludingTax = numberValue
            }
        }
        
        if let stringValue = jsonDictionary["cost_inc_tax"] as? String {
            if let numberValue = numberFormatter.number(from: stringValue) {
                self.costIncludingTax = numberValue
            }
        }
        
        if let stringValue = jsonDictionary["cost_tax"] as? String {
            if let numberValue = numberFormatter.number(from: stringValue) {
                self.costTax = numberValue
            }
        }
        
        if let numberValue = jsonDictionary["cost_tax_class_id"] as? NSNumber {
            self.costTaxClassId = numberValue
        }
        
        if let stringValue = jsonDictionary["handling_cost_ex_tax"] as? String {
            if let numberValue = numberFormatter.number(from: stringValue) {
                self.handlingCostExcludingTax = numberValue
            }
        }
        
        if let stringValue = jsonDictionary["handling_cost_inc_tax"] as? String {
            if let numberValue = numberFormatter.number(from: stringValue) {
                self.handlingCostIncludingTax = numberValue
            }
        }
        
        if let stringValue = jsonDictionary["handling_cost_tax"] as? String {
            if let numberValue = numberFormatter.number(from: stringValue) {
                self.handlingCostTax = numberValue
            }
        }
        
        if let numberValue = jsonDictionary["handling_cost_tax_class_id"] as? NSNumber {
            self.handlingCostTaxClassId = numberValue
        }
        
        if let numberValue = jsonDictionary["shipping_zone_id"] as? NSNumber {
            self.shippingZoneId = numberValue
        }
        
        if let stringValue = jsonDictionary["shipping_zone_name"] as? String {
            self.shippingZoneName = stringValue
        }
    }

}
