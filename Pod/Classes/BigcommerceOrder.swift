//
//  BigcommerceOrder.swift
//  
//
//  Created by William Welbes on 6/23/15.
//
//

import Foundation

public class BigcommerceOrder: NSObject {
    public var totalExcludingTax: NSNumber = 0
    public var totalIncludingTax: NSNumber = 0
    public var totalTax: NSNumber = 0
    
    public var subtotalExcludingTax: NSNumber = 0
    public var subtotalIncludingTax: NSNumber = 0
    public var subtotalTax: NSNumber = 0
    
    public var shippingCostExcludingTax: NSNumber = 0
    public var shippingCostIncludingTax: NSNumber = 0
    public var shippingCostTax: NSNumber = 0
    
    public var status: String = ""
    public var statusId: NSNumber?
    
    public var billingFirstName: String = ""
    public var billingLastName: String = ""
    public var billingEmail: String = ""
    public var billingCompany: String = ""
    public var billingStreet1: String = ""
    public var billingStreet2: String = ""
    public var billingCity: String = ""
    public var billingState: String = ""
    public var billingZip: String = ""
    public var billingCountry: String = ""
    public var billingPhone: String = ""
    
    public var dateCreated: NSDate?
    public var dateModified: NSDate?
    public var dateShipped: NSDate?
    
    public var orderId: NSNumber?
    
    public init(jsonDictionary:NSDictionary) {
        //Load the JSON dictionary into the order object
        
        //Float values are returned as quote enclosed strings in the JSON from the API
        let numberFormatter = NSNumberFormatter()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE, d MMM yyyy HH:mm:ss zzz"
        
        if let id = jsonDictionary["id"] as? NSNumber {
            orderId = id
        }
        
        if let stringValue = jsonDictionary["status"] as? String {
            status = stringValue
        }
        
        if let id = jsonDictionary["status_id"] as? NSNumber {
            statusId = id
        }
        
        if let stringValue = jsonDictionary["total_ex_tax"] as? String {
            if let numberValue = numberFormatter.numberFromString(stringValue) {
                totalExcludingTax = numberValue
            }
        }
        
        if let stringValue = jsonDictionary["total_inc_tax"] as? String {
            if let numberValue = numberFormatter.numberFromString(stringValue) {
                totalIncludingTax = numberValue
            }
        }
        
        if let stringValue = jsonDictionary["total_tax"] as? String {
            if let numberValue = numberFormatter.numberFromString(stringValue) {
                totalTax = numberValue
            }
        }
        
        if let stringValue = jsonDictionary["subtotal_ex_tax"] as? String {
            if let numberValue = numberFormatter.numberFromString(stringValue) {
                subtotalExcludingTax = numberValue
            }
        }
        
        if let stringValue = jsonDictionary["subtotal_inc_tax"] as? String {
            if let numberValue = numberFormatter.numberFromString(stringValue) {
                subtotalIncludingTax = numberValue
            }
        }
        
        if let stringValue = jsonDictionary["subtotal_tax"] as? String {
            if let numberValue = numberFormatter.numberFromString(stringValue) {
                subtotalTax = numberValue
            }
        }
        
        if let stringValue = jsonDictionary["shipping_cost_ex_tax"] as? String {
            if let numberValue = numberFormatter.numberFromString(stringValue) {
                shippingCostExcludingTax = numberValue
            }
        }
        
        if let stringValue = jsonDictionary["shipping_cost_inc_tax"] as? String {
            if let numberValue = numberFormatter.numberFromString(stringValue) {
                shippingCostIncludingTax = numberValue
            }
        }
        
        if let stringValue = jsonDictionary["shipping_cost_tax"] as? String {
            if let numberValue = numberFormatter.numberFromString(stringValue) {
                shippingCostTax = numberValue
            }
        }
        
        //Load the billing parameters
        if let billingDict = jsonDictionary["billing_address"] as? NSDictionary {
            
            if let stringValue = billingDict["first_name"] as? String {
                billingFirstName = stringValue
            }
            
            if let stringValue = billingDict["last_name"] as? String {
                billingLastName = stringValue
            }
            
            if let stringValue = billingDict["email"] as? String {
                billingEmail = stringValue
            }
            
            if let stringValue = billingDict["phone"] as? String {
                billingPhone = stringValue
            }
            
            if let stringValue = billingDict["company"] as? String {
                billingCompany = stringValue
            }
            
            if let stringValue = billingDict["street_1"] as? String {
                billingStreet1 = stringValue
            }
            
            if let stringValue = billingDict["street_2"] as? String {
                billingStreet2 = stringValue
            }
            
            if let stringValue = billingDict["city"] as? String {
                billingCity = stringValue
            }
            
            if let stringValue = billingDict["state"] as? String {
                billingState = stringValue
            }
            
            if let stringValue = billingDict["zip"] as? String {
                billingZip = stringValue
            }
            
            if let stringValue = billingDict["country"] as? String {
                billingCountry = stringValue
            }
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
        
        if let dateString = jsonDictionary["date_shipped"] as? String {
            if let date = dateFormatter.dateFromString(dateString) {
                dateShipped = date
            }
        }
    }
}
