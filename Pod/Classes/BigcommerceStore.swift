//
//  BigcommerceStore.swift
//  Pods
//
//  Created by William Welbes on 11/30/15.
//
//

import Foundation

public class BigcommerceStore: NSObject {
    public var id: String = ""
    public var name: String = ""
    public var domain: String = ""
    public var address: String = ""
    public var phone: String = ""
    public var adminEmail:String = ""
    public var orderEmail:String = ""
    public var language:String = ""
    public var currency:String = ""
    public var currencySymbol:String = ""
    public var decimalSeparator:String = "."
    public var thousandsSeparator:String = ","
    public var decimalPlaces:Int = 2
    public var currencySymbolLocation:String = "left"
    public var weightUnits:String = "LBS"
    public var dimensionUnits:String = "Inches"
    public var dimensionDecimalPlaces:Int = 2
    public var dimensionDecimalToken:String = "."
    public var dimensionThousandsToken:String = ","
    public var planName:String = ""
    public var logoUrl:String?
    
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