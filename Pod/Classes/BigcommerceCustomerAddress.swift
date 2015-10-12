//
//  BigcommerceCustomerAddress.swift
//  Pods
//
//  Created by William Welbes on 10/12/15.
//
//

import Foundation

public class BigcommerceCustomerAddress: NSObject {
    public var customerAddressId: NSNumber?
    public var customerId:NSNumber?
    
    public var firstName:String = ""
    public var lastName:String = ""
    public var company:String = ""
    
    public var street1: String = ""
    public var street2: String = ""
    public var city: String = ""
    public var state: String = ""
    public var zip: String = ""
    public var country: String = ""
    public var countryISO2: String = ""
    
    public var phone:String = ""
    
    public init(jsonDictionary:NSDictionary) {
        //Load the JSON dictionary into the order object
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE, d MMM yyyy HH:mm:ss zzz"
        
        if let id = jsonDictionary["id"] as? NSNumber {
            self.customerAddressId = id
        }
        
        if let id = jsonDictionary["customer_id"] as? NSNumber {
            self.customerId = id
        }
        
        if let stringValue = jsonDictionary["first_name"] as? String {
            self.firstName = stringValue
        }
        
        if let stringValue = jsonDictionary["last_name"] as? String {
            self.lastName = stringValue
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
        
        if let stringValue = jsonDictionary["phone"] as? String {
            self.phone = stringValue
        }
    }
    
    public override var description: String {
        //let mirror = Mirror(reflecting: self)
        
        let customerAddressIdString = self.customerAddressId != nil ? self.customerAddressId!.stringValue : ""
        
        let description = "Customer Address \(customerAddressIdString) : \(self.firstName) \(self.lastName)"
        
        return description
    }
}