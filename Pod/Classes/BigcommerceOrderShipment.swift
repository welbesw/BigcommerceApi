//
//  BigcommerceOrderShipment.swift
//  Pods
//
//  Created by William Welbes on 10/19/15.
//
//

import Foundation

open class BigcommerceOrderShipment: NSObject {
    open var orderId: NSNumber?
    open var shipmentId:NSNumber?
    open var customerId:NSNumber?
    
    open var trackingNumber:String = ""
    open var shippingMethod:String = ""
    open var comments:String = ""
    
    open var shipmentItems:[BigcommerceOrderShipmentItem] = []
    
    open var dateCreated:Date?
    open var dateModified:Date?
    
    public init(jsonDictionary:NSDictionary) {
        //Load the JSON dictionary into the order object
        
        let dateFormatter = DateFormatter()
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
        
        let shipmentIdString = self.shipmentId != nil ? self.shipmentId!.stringValue : ""
        
        let description = "Order Shipment \(shipmentIdString)"
        
        return description
    }
}
