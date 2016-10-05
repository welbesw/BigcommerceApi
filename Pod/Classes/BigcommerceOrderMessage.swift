//
//  BigcommerceOrderMessage.swift
//  Pods
//
//  Created by William Welbes on 10/30/15.
//
//

import Foundation

open class BigcommerceOrderMessage: NSObject {
    open var orderMessageId:NSNumber?
    open var orderId: NSNumber?
    open var staffId:NSNumber?
    open var customerId:NSNumber?
    
    open var type:String?
    
    open var subject:String = ""
    open var message:String = ""
    
    open var status:String?
    open var isFlagged:Bool = false
    
    open var dateCreated:Date?
    
    public init(jsonDictionary:NSDictionary) {
        //Load the JSON dictionary into the order object
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, d MMM yyyy HH:mm:ss zzz"
        
        if let id = jsonDictionary["id"] as? NSNumber {
            self.orderMessageId = id
        }
        
        if let id = jsonDictionary["order_id"] as? NSNumber {
            self.orderId = id
        }
        
        if let id = jsonDictionary["customer_id"] as? NSNumber {
            self.customerId = id
        }
        
        if let id = jsonDictionary["staff_id"] as? NSNumber {
            self.staffId = id
        }
        
        if let stringValue = jsonDictionary["type"] as? String {
            self.type = stringValue
        }
        
        if let stringValue = jsonDictionary["subject"] as? String {
            self.subject = stringValue
        }
        
        if let stringValue = jsonDictionary["message"] as? String {
            self.message = stringValue
        }
        
        if let stringValue = jsonDictionary["status"] as? String {
            self.status = stringValue
        }
        
        if let numberValue = jsonDictionary["is_flagged"] as? NSNumber {
            self.isFlagged = numberValue.boolValue
        }

        
        if let dateString = jsonDictionary["date_created"] as? String {
            if let date = dateFormatter.date(from: dateString) {
                dateCreated = date
            }
        }
        
    }
    
    open override var description: String {
        
        let shipmentIdString = self.orderMessageId != nil ? self.orderMessageId!.stringValue : ""
        
        let description = "Order Message \(shipmentIdString)"
        
        return description
    }
}
