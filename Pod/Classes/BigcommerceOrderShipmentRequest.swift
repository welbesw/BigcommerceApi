//
//  BigcommerceOrderShipmentRequest.swift
//  Pods
//
//  Created by William Welbes on 7/30/16.
//
//

import Foundation

public enum BigcommerceShippingProvider:String {
    case AUSPost = "auspost"
    case CanadaPost = "canadapost"
    case Endicia = "endicia"
    case USPS = "usps"
    case Fedex = "fedex"
    case RoyalMain = "royalmail"
    case UPS = "ups"
    case UPSReady = "upsready"
    case UPSOnline = "upsonline"
    case ShipperHQ = "shipperhq"
}

open class BigcommerceOrderShipmentRequestItem : NSObject {
    
    var orderProductId:Int = 0
    var quantity:Int = 0
    
    func jsonDictionary() -> [String : AnyObject] {
        var dictionary:[String : AnyObject] = [:]
        
        dictionary.updateValue(orderProductId as AnyObject, forKey: "order_product_id")
        dictionary.updateValue(quantity as AnyObject, forKey: "quantity")
        
        return dictionary
    }
}

open class BigcommerceOrderShipmentRequest: NSObject {
    
    var orderId:Int = 0
    var items:[BigcommerceOrderShipmentRequestItem] = []
    var comments:String?
    var trackingNumber:String?
    var orderAddressId:Int = 0
    var shippingProvider:BigcommerceShippingProvider?
    
    func jsonDictionary() -> [String : AnyObject] {
        var dictionary:[String : AnyObject] = [:]
        
        var itemDictArray:[[String : AnyObject]] = []
        for item in items {
            let itemDict = item.jsonDictionary()
            itemDictArray.append(itemDict)
        }
        dictionary.updateValue(itemDictArray as AnyObject, forKey: "items")
        
        if let commentsText = self.comments {
            dictionary.updateValue(commentsText as AnyObject, forKey: "comments")
        }
        
        if let tracking = self.trackingNumber {
            dictionary.updateValue(tracking as AnyObject, forKey: "tracking_number")
        }
        
        dictionary.updateValue(orderAddressId as AnyObject, forKey: "order_address_id")
        
        if let provider = self.shippingProvider {
            dictionary.updateValue(provider.rawValue as AnyObject, forKey: "shipping_provider")
        }
        
        return dictionary
    }
}
