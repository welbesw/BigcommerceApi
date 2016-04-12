//
//  BigcommerceOrderShippingAddress.swift
//  Pods
//
//  Created by William Welbes on 8/24/15.
//
//

import Foundation

public class BigcommerceOrderShippingAddress: NSObject {
    
    public var id: NSNumber?
    public var orderId: NSNumber?
    
    public var firstName: String = ""
    public var lastName: String = ""
    public var company: String = ""

    public var street1: String = ""
    public var street2: String = ""
    public var city: String = ""
    public var zip: String = ""
    public var country: String = ""
    public var countryISO2: String = ""
    public var state: String = ""
    public var email: String = ""
    public var phone: String = ""
    
    public var itemsTotal: NSNumber = 0
    public var itemsShipped: NSNumber = 0
    public var shippingMethod: String = ""

    public var baseCost: NSNumber = 0
    public var costExcludingTax: NSNumber = 0
    public var costIncludingTax: NSNumber = 0
    public var costTax: NSNumber = 0
    public var costTaxClassId: NSNumber?

    public var baseHandlingCost: NSNumber = 0
    public var handlingCostExcludingTax: NSNumber = 0
    public var handlingCostIncludingTax: NSNumber = 0
    public var handlingCostTax: NSNumber = 0
    public var handlingCostTaxClassId: NSNumber?
    
    public var shippingZoneId: NSNumber?
    public var shippingZoneName: String = ""
    
    public init(jsonDictionary:NSDictionary, currencyCode:String) {
        //Load the JSON dictionary into the shipping address object
        
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
            if let numberValue = numberFormatter.numberFromString(stringValue) {
                self.baseCost = numberValue
            }
        }
        
        if let stringValue = jsonDictionary["cost_ex_tax"] as? String {
            if let numberValue = numberFormatter.numberFromString(stringValue) {
                self.costExcludingTax = numberValue
            }
        }
        
        if let stringValue = jsonDictionary["cost_inc_tax"] as? String {
            if let numberValue = numberFormatter.numberFromString(stringValue) {
                self.costIncludingTax = numberValue
            }
        }
        
        if let stringValue = jsonDictionary["cost_tax"] as? String {
            if let numberValue = numberFormatter.numberFromString(stringValue) {
                self.costTax = numberValue
            }
        }
        
        if let numberValue = jsonDictionary["cost_tax_class_id"] as? NSNumber {
            self.costTaxClassId = numberValue
        }
        
        if let stringValue = jsonDictionary["handling_cost_ex_tax"] as? String {
            if let numberValue = numberFormatter.numberFromString(stringValue) {
                self.handlingCostExcludingTax = numberValue
            }
        }
        
        if let stringValue = jsonDictionary["handling_cost_inc_tax"] as? String {
            if let numberValue = numberFormatter.numberFromString(stringValue) {
                self.handlingCostIncludingTax = numberValue
            }
        }
        
        if let stringValue = jsonDictionary["handling_cost_tax"] as? String {
            if let numberValue = numberFormatter.numberFromString(stringValue) {
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