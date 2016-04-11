//
//  BigcommerceCustomer.swift
//  Pods
//
//  Created by William Welbes on 10/12/15.
//
//

import Foundation

public class BigcommerceCustomer: NSObject {
    public var customerId: NSNumber?
    
    public var company:String = ""
    public var firstName:String = ""
    public var lastName:String = ""
    public var email:String = ""
    public var phone:String = ""
    
    public var storeCredit:NSNumber = 0.0
    public var registrationIpAddress:String = ""
    public var customerGroupId:NSNumber?
    
    public var notes = ""
    public var taxExemptCategory = ""
    
    public var dateCreated:NSDate?
    public var dateModified:NSDate?
    
    public var addresses:[BigcommerceCustomerAddress] = []
    
    public init(jsonDictionary:NSDictionary) {
        //Load the JSON dictionary into the order object
        
        //Float values are returned as quote enclosed strings in the JSON from the API
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        let dateFormatter = NSDateFormatter()
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
            if let numberValue = numberFormatter.numberFromString(stringValue) {
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
    
    public override var description: String {
        //let mirror = Mirror(reflecting: self)
        
        let customerIdString = self.customerId != nil ? self.customerId!.stringValue : ""
        
        let description = "Customer \(customerIdString) : \(self.firstName) \(self.lastName)"
        
        return description
    }
}