//
//  BigcommerceOrderMessage.swift
//  Pods
//
//  Created by William Welbes on 10/30/15.
//
//

import Foundation

public class BigcommerceOrderMessage: NSObject {
    public var orderMessageId:NSNumber?
    public var orderId: NSNumber?
    public var staffId:NSNumber?
    public var customerId:NSNumber?
    
    public var type:String?
    
    public var subject:String = ""
    public var message:String = ""
    
    public var status:String?
    public var isFlagged:Bool = false
    
    public var dateCreated:NSDate?
    
    public init(jsonDictionary:NSDictionary) {
        //Load the JSON dictionary into the order object
        
        let dateFormatter = NSDateFormatter()
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
            if let date = dateFormatter.dateFromString(dateString) {
                dateCreated = date
            }
        }
        
    }
    
    public override var description: String {
        
        let shipmentIdString = self.orderMessageId != nil ? self.orderMessageId!.stringValue : ""
        
        let description = "Order Message \(shipmentIdString)"
        
        return description
    }
}