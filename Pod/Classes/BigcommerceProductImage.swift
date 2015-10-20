//
//  BigcommerceProductImage.swift
//  Pods
//
//  Created by William Welbes on 10/20/15.
//
//

import Foundation

public class BigcommerceProductImage: NSObject {
    public var productImageId:NSNumber?
    public var productId:NSNumber?
    
    public var imageFile:String?
    public var zoomUrl:String?
    public var thumbnailUrl:String?
    public var standardUrl:String?
    public var tinyUrl:String?
    
    public var isThumbnail:Bool = false
    
    public var sortOrder:NSNumber = 0
    public var imageDescription:String?
    
    public var dateCreated:NSDate?
    public var dateModified:NSDate?
    
    public init(jsonDictionary:NSDictionary) {
        //Load the JSON dictionary into the object
        
        let dateFormatter = NSDateFormatter()
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
            self.sortOrder = numberValue.boolValue
        }
        
        if let stringValue = jsonDictionary["description"] as? String {
            self.imageDescription = stringValue
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
}