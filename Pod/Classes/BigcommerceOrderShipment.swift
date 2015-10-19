//
//  BigcommerceOrderShipment.swift
//  Pods
//
//  Created by William Welbes on 10/19/15.
//
//

import Foundation

public class BigcommerceOrderShipment: NSObject {
    public var orderId: NSNumber?
    public var shipmentId:NSNumber?
    public var customerId:NSNumber?
    
    public var trackingNumber:String = ""
    public var shippingMethod:String = ""
    public var comments:String = ""
    
    public var shipmentItems:[BigcommerceOrderShipmentItem] = []
    
    public var dateCreated:NSDate?
    public var dateModified:NSDate?
    
    public init(jsonDictionary:NSDictionary) {
        //Load the JSON dictionary into the order object
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE, d MMM yyyy HH:mm:ss zzz"
        
        if let id = jsonDictionary["id"] as? NSNumber {
            self.shipmentId = id
        }
        
        if let id = jsonDictionary["order_id"] as? NSNumber {
            self.orderId = id
        }
        
        if let id = jsonDictionary["customer_id"] as? NSNumber {
            self.customerId = id
        }
        
        if let stringValue = jsonDictionary["tracking_number"] as? String {
            self.trackingNumber = stringValue
        }
        
        if let stringValue = jsonDictionary["shipping_method"] as? String {
            self.shippingMethod = stringValue
        }
        
        if let itemsArray = jsonDictionary["items"] as? Array<NSDictionary> {
            for itemDict in itemsArray {
                let shipmentItem = BigcommerceOrderShipmentItem(jsonDictionary: itemDict)
                shipmentItems.append(shipmentItem)
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
        
    }
    
    public override var description: String {
        
        let shipmentIdString = self.shipmentId != nil ? self.shipmentId!.stringValue : ""
        
        let description = "Order Shipment \(shipmentIdString)"
        
        return description
    }
}