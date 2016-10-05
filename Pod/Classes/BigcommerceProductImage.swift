//
//  BigcommerceProductImage.swift
//  Pods
//
//  Created by William Welbes on 10/20/15.
//
//

import Foundation

open class BigcommerceProductImage: NSObject {
    open var productImageId:NSNumber?
    open var productId:NSNumber?
    
    open var imageFile:String?
    open var zoomUrl:String?
    open var thumbnailUrl:String?
    open var standardUrl:String?
    open var tinyUrl:String?
    
    open var isThumbnail:Bool = false
    
    open var sortOrder:NSNumber = 0
    open var imageDescription:String?
    
    open var dateCreated:Date?
    open var dateModified:Date?
    
    public init(jsonDictionary:NSDictionary) {
        //Load the JSON dictionary into the object
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, d MMM yyyy HH:mm:ss zzz"
        
        if let id = jsonDictionary["id"] as? NSNumber {
            self.productImageId = id
        }
        
        if let stringValue = jsonDictionary["image_file"] as? String {
            self.imageFile = stringValue
        }
        
        if let stringValue = jsonDictionary["zoom_url"] as? String {
            self.zoomUrl = stringValue
        }
        
        if let stringValue = jsonDictionary["thumbnail_url"] as? String {
            self.thumbnailUrl = stringValue
        }
        
        if let stringValue = jsonDictionary["standard_url"] as? String {
            self.standardUrl = stringValue
        }
        
        if let stringValue = jsonDictionary["tiny_url"] as? String {
            self.tinyUrl = stringValue
        }
        
        if let numberValue = jsonDictionary["is_thumbnail"] as? NSNumber {
            self.isThumbnail = numberValue.boolValue
        }
        
        if let numberValue = jsonDictionary["sort_order"] as? NSNumber {
            self.sortOrder = numberValue.boolValue as NSNumber
        }
        
        if let stringValue = jsonDictionary["description"] as? String {
            self.imageDescription = stringValue
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
}
