//
//  BigcommerceOrder.swift
//  
//
//  Created by William Welbes on 6/23/15.
//
//

import Foundation

open class BigcommerceOrder: NSObject {
    open var totalExcludingTax: NSNumber = 0
    open var totalIncludingTax: NSNumber = 0
    open var totalTax: NSNumber = 0
    
    open var subtotalExcludingTax: NSNumber = 0
    open var subtotalIncludingTax: NSNumber = 0
    open var subtotalTax: NSNumber = 0
    
    open var shippingCostExcludingTax: NSNumber = 0
    open var shippingCostIncludingTax: NSNumber = 0
    open var shippingCostTax: NSNumber = 0
    
    open var refundedAmount: NSNumber = 0
    open var couponDiscountAmount: NSNumber = 0
    open var discountAmount: NSNumber = 0
    
    open var ipAddress: String = ""
    
    open var status: String = ""
    open var statusId: NSNumber?
    
    open var billingFirstName: String = ""
    open var billingLastName: String = ""
    open var billingEmail: String = ""
    open var billingCompany: String = ""
    open var billingStreet1: String = ""
    open var billingStreet2: String = ""
    open var billingCity: String = ""
    open var billingState: String = ""
    open var billingZip: String = ""
    open var billingCountry: String = ""
    open var billingPhone: String = ""
    
    open var dateCreated: Date?
    open var dateModified: Date?
    open var dateShipped: Date?
    
    open var orderId: NSNumber?
    open var staffNotes: String?
    open var customerMessage: String?
    
    open var paymentMethod:String?
    open var paymentStatus:String?
    open var paymentProviderId:NSNumber?
    
    open var productsResource: String = ""
    open var productsUrl: String = ""
    
    open var shippingAddressesResource: String = ""
    open var shippingAddressesUrl: String = ""
    
    open var couponsResource = ""
    open var couponsUrl = ""
    
    open var currencyCode = "USD" //Assume USD
    open var currencyLocale:Locale?
    
    public init(jsonDictionary:NSDictionary) {
        //Load the JSON dictionary into the order object
        
        //Float values are returned as quote enclosed strings in the JSON from the API
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        
        if let stringValue = jsonDictionary["currency_code"] as? String {
            currencyCode = stringValue
        }
        
        var components:[String : String] = [NSLocale.Key.currencyCode.rawValue : currencyCode]
        if let language = Locale.preferredLanguages.first {
            components.updateValue(language, forKey: NSLocale.Key.languageCode.rawValue)
        }
        let localeIdentifier = Locale.identifier(fromComponents: components)
        currencyLocale = Locale(identifier: localeIdentifier);
        
        numberFormatter.locale = currencyLocale
        
        let dateFormatter = DateFormatter()
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
        
        if let stringValue = jsonDictionary["staff_notes"] as? String {
            staffNotes = stringValue
        }
        
        if let stringValue = jsonDictionary["customer_message"] as? String {
            customerMessage = stringValue
        }
        
        if let stringValue = jsonDictionary["payment_method"] as? String {
            paymentMethod = stringValue
        }
        
        if let stringValue = jsonDictionary["payment_status"] as? String {
            paymentStatus = stringValue
        }
        
        if let numberValue = jsonDictionary["payment_provider_id"] as? NSNumber {
            paymentProviderId = numberValue
        }
        
        if let stringValue = jsonDictionary["total_ex_tax"] as? String {
            if let numberValue = numberFormatter.number(from: stringValue) {
                totalExcludingTax = numberValue
            }
        }
        
        if let stringValue = jsonDictionary["total_inc_tax"] as? String {
            if let numberValue = numberFormatter.number(from: stringValue) {
                totalIncludingTax = numberValue
            }
        }
        
        if let stringValue = jsonDictionary["total_tax"] as? String {
            if let numberValue = numberFormatter.number(from: stringValue) {
                totalTax = numberValue
            }
        }
        
        if let stringValue = jsonDictionary["subtotal_ex_tax"] as? String {
            if let numberValue = numberFormatter.number(from: stringValue) {
                subtotalExcludingTax = numberValue
            }
        }
        
        if let stringValue = jsonDictionary["subtotal_inc_tax"] as? String {
            if let numberValue = numberFormatter.number(from: stringValue) {
                subtotalIncludingTax = numberValue
            }
        }
        
        if let stringValue = jsonDictionary["subtotal_tax"] as? String {
            if let numberValue = numberFormatter.number(from: stringValue) {
                subtotalTax = numberValue
            }
        }
        
        if let stringValue = jsonDictionary["shipping_cost_ex_tax"] as? String {
            if let numberValue = numberFormatter.number(from: stringValue) {
                shippingCostExcludingTax = numberValue
            }
        }
        
        if let stringValue = jsonDictionary["shipping_cost_inc_tax"] as? String {
            if let numberValue = numberFormatter.number(from: stringValue) {
                shippingCostIncludingTax = numberValue
            }
        }
        
        if let stringValue = jsonDictionary["shipping_cost_tax"] as? String {
            if let numberValue = numberFormatter.number(from: stringValue) {
                shippingCostTax = numberValue
            }
        }
        
        if let stringValue = jsonDictionary["refunded_amount"] as? String {
            if let numberValue = numberFormatter.number(from: stringValue) {
                refundedAmount = numberValue
            }
        }
        
        if let stringValue = jsonDictionary["coupon_discount"] as? String {
            if let numberValue = numberFormatter.number(from: stringValue) {
                couponDiscountAmount = numberValue
            }
        }
        
        if let stringValue = jsonDictionary["discount_amount"] as? String {
            if let numberValue = numberFormatter.number(from: stringValue) {
                discountAmount = numberValue
            }
        }
        
        if let stringValue = jsonDictionary["ip_address"] as? String {
            ipAddress = stringValue
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
            if let date = dateFormatter.date(from: dateString) {
                dateCreated = date
            }
        }
        
        if let dateString = jsonDictionary["date_modified"] as? String {
            if let date = dateFormatter.date(from: dateString) {
                dateModified = date
            }
        }
        
        if let dateString = jsonDictionary["date_shipped"] as? String {
            if let date = dateFormatter.date(from: dateString) {
                dateShipped = date
            }
        }
        
        if let productsDict = jsonDictionary["products"] as? NSDictionary {
            if let resource = productsDict["resource"] as? String {
                productsResource = resource
            }
            if let url = productsDict["url"] as? String {
                productsUrl = url
            }
        }
        
        if let shippingAddressesDict = jsonDictionary["shipping_addresses"] as? NSDictionary {
            if let resource = shippingAddressesDict["resource"] as? String {
                shippingAddressesResource = resource
            }
            if let url = shippingAddressesDict["url"] as? String {
                shippingAddressesUrl = url
            }
        }
        
        if let couponsDict = jsonDictionary["coupons"] as? NSDictionary {
            if let resource = couponsDict["resource"] as? String {
                couponsResource = resource
            }
            if let url = couponsDict["url"] as? String {
                couponsUrl = url
            }
        }
    }
    
    open override var description: String {
        //let mirror = Mirror(reflecting: self)
        
        let orderIdString = self.orderId != nil ? self.orderId!.stringValue : ""
        let orderStatusIdString = self.statusId != nil ? self.statusId!.stringValue : ""
        var description = "Order \(orderIdString) : \(self.billingFirstName) \(self.billingLastName)"
        description += "\nStatus: \(self.status) : \(orderStatusIdString)"
        
        return description
    }
}
