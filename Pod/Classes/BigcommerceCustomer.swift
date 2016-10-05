//
//  BigcommerceCustomer.swift
//  Pods
//
//  Created by William Welbes on 10/12/15.
//
//

import Foundation

open class BigcommerceCustomer: NSObject {
    open var customerId: NSNumber?
    
    open var company:String = ""
    open var firstName:String = ""
    open var lastName:String = ""
    open var email:String = ""
    open var phone:String = ""
    
    open var storeCredit:NSNumber = 0.0
    open var registrationIpAddress:String = ""
    open var customerGroupId:NSNumber?
    
    open var notes = ""
    open var taxExemptCategory = ""
    
    open var dateCreated:Date?
    open var dateModified:Date?
    
    open var addresses:[BigcommerceCustomerAddress] = []
    
    public init(jsonDictionary:NSDictionary) {
        //Load the JSON dictionary into the order object
        
        //Float values are returned as quote enclosed strings in the JSON from the API
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        
        var components:[String : String] = [NSLocale.Key.currencyCode.rawValue : "USD"] //Assume USD
        if let language = Locale.preferredLanguages.first {
            components.updateValue(language, forKey: NSLocale.Key.languageCode.rawValue)
        }
        let localeIdentifier = Locale.identifier(fromComponents: components)
        let localeForCurrency = Locale(identifier: localeIdentifier);
        numberFormatter.locale = localeForCurrency
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, d MMM yyyy HH:mm:ss zzz"
        
        if let id = jsonDictionary["id"] as? NSNumber {
            self.customerId = id
        }
        
        if let stringValue = jsonDictionary["first_name"] as? String {
            self.firstName = stringValue
        }
        
        if let stringValue = jsonDictionary["last_name"] as? String {
            self.lastName = stringValue
        }
        
        if let stringValue = jsonDictionary["email"] as? String {
            self.email = stringValue
        }
        
        if let stringValue = jsonDictionary["phone"] as? String {
            self.phone = stringValue
        }
        
        if let stringValue = jsonDictionary["store_credit"] as? String {
            if let numberValue = numberFormatter.number(from: stringValue) {
                storeCredit = numberValue
            }
        }
        
        if let stringValue = jsonDictionary["registration_ip_address"] as? String {
            self.registrationIpAddress = stringValue
        }
        
        if let numberValue = jsonDictionary["customer_group_id"] as? NSNumber {
            self.customerGroupId = numberValue
        }
        
        if let stringValue = jsonDictionary["notes"] as? String {
            self.notes = stringValue
        }
        
        if let stringValue = jsonDictionary["tax_exempt_category"] as? String {
            self.taxExemptCategory = stringValue
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
    
    open override var description: String {
        //let mirror = Mirror(reflecting: self)
        
        let customerIdString = self.customerId != nil ? self.customerId!.stringValue : ""
        
        let description = "Customer \(customerIdString) : \(self.firstName) \(self.lastName)"
        
        return description
    }
}
