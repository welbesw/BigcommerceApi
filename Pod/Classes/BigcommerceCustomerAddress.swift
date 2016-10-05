//
//  BigcommerceCustomerAddress.swift
//  Pods
//
//  Created by William Welbes on 10/12/15.
//
//

import Foundation

open class BigcommerceCustomerAddress: NSObject {
    open var customerAddressId: NSNumber?
    open var customerId:NSNumber?
    
    open var firstName:String = ""
    open var lastName:String = ""
    open var company:String = ""
    
    open var street1: String = ""
    open var street2: String = ""
    open var city: String = ""
    open var state: String = ""
    open var zip: String = ""
    open var country: String = ""
    open var countryISO2: String = ""
    
    open var phone:String = ""
    
    public init(jsonDictionary:NSDictionary) {
        //Load the JSON dictionary into the order object
        
        let dateFormatter = DateFormatter()
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
    
    open override var description: String {
        //let mirror = Mirror(reflecting: self)
        
        let customerAddressIdString = self.customerAddressId != nil ? self.customerAddressId!.stringValue : ""
        
        let description = "Customer Address \(customerAddressIdString) : \(self.firstName) \(self.lastName)"
        
        return description
    }
}
