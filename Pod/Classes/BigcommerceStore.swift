//
//  BigcommerceStore.swift
//  Pods
//
//  Created by William Welbes on 11/30/15.
//
//

import Foundation

open class BigcommerceStore: NSObject {
    open var id: String = ""
    open var name: String = ""
    open var domain: String = ""
    open var address: String = ""
    open var phone: String = ""
    open var adminEmail:String = ""
    open var orderEmail:String = ""
    open var language:String = ""
    open var currency:String = ""
    open var currencySymbol:String = ""
    open var decimalSeparator:String = "."
    open var thousandsSeparator:String = ","
    open var decimalPlaces:Int = 2
    open var currencySymbolLocation:String = "left"
    open var weightUnits:String = "LBS"
    open var dimensionUnits:String = "Inches"
    open var dimensionDecimalPlaces:Int = 2
    open var dimensionDecimalToken:String = "."
    open var dimensionThousandsToken:String = ","
    open var planName:String = ""
    open var logoUrl:String?
    
    public init(jsonDictionary:NSDictionary) {
        //Load the JSON dictionary into the order object
        
        if let idString = jsonDictionary["id"] as? String {
            self.id = idString
        }
        
        if let name = jsonDictionary["name"] as? String {
            self.name = name
        }
        
        if let stringValue = jsonDictionary["domain"] as? String {
            self.domain = stringValue
        }
        
        if let stringValue = jsonDictionary["address"] as? String {
            self.address = stringValue
        }
        
        if let stringValue = jsonDictionary["phone"] as? String {
            self.phone = stringValue
        }
        
        if let stringValue = jsonDictionary["admin_email"] as? String {
            self.adminEmail = stringValue
        }
        
        if let stringValue = jsonDictionary["order_email"] as? String {
            self.orderEmail = stringValue
        }
        
        if let stringValue = jsonDictionary["language"] as? String {
            self.language = stringValue
        }
        
        if let stringValue = jsonDictionary["currency"] as? String {
            self.currency = stringValue
        }
        
        if let stringValue = jsonDictionary["currency_symbol"] as? String {
            self.currencySymbol = stringValue
        }
        
        if let stringValue = jsonDictionary["decimal_separator"] as? String {
            self.decimalSeparator = stringValue
        }
        
        if let stringValue = jsonDictionary["thousands_separator"] as? String {
            self.thousandsSeparator = stringValue
        }
        
        if let stringValue = jsonDictionary["decimal_places"] as? String {
            if let intValue = Int(stringValue) {
                self.decimalPlaces = intValue
            }
        }
        
        if let stringValue = jsonDictionary["currency_symbol_location"] as? String {
            self.currencySymbolLocation = stringValue
        }
        
        if let stringValue = jsonDictionary["weight_units"] as? String {
            self.weightUnits = stringValue
        }
        
        if let stringValue = jsonDictionary["dimension_units"] as? String {
            self.dimensionUnits = stringValue
        }
        
        if let stringValue = jsonDictionary["dimension_units"] as? String {
            self.dimensionUnits = stringValue
        }
        
        if let stringValue = jsonDictionary["dimension_decimal_places"] as? String {
            if let intValue = Int(stringValue) {
                self.dimensionDecimalPlaces = intValue
            }
        }
        
        if let stringValue = jsonDictionary["dimension_decimal_token"] as? String {
            self.dimensionDecimalToken = stringValue
        }
        
        if let stringValue = jsonDictionary["dimension_thousands_token"] as? String {
            self.dimensionThousandsToken = stringValue
        }
        
        if let stringValue = jsonDictionary["plan_name"] as? String {
            self.planName = stringValue
        }
        
        if let logoDict = jsonDictionary["logo"] as? NSDictionary {
            if let stringValue = logoDict["url"] as? String {
                self.logoUrl = stringValue
            }
        }
    }
}
