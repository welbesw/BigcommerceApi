//
//  DefaultsManager.swift
//  BigcommerceApi
//
//  Created by William Welbes on 7/7/15.
//  Copyright (c) 2015 CocoaPods. All rights reserved.
//

import UIKit

public class DefaultsManager: NSObject {
   
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    var orderStatusIdFilter: Int? = nil //Allows the user to filter based on a specific order status
    
    var apiUsername: String? {
        get {
            return userDefaults.stringForKey("ApiUsername")
        }
        set(newValue) {
            userDefaults.setValue(newValue, forKey: "ApiUsername")
        }
    }
    
    var apiToken: String? {
        get {
            return userDefaults.stringForKey("ApiToken")
        }
        set(newValue) {
            userDefaults.setValue(newValue, forKey: "ApiToken")
        }
    }
    
    var apiStoreBaseUrl: String? {
        get {
            return userDefaults.stringForKey("ApiStoreBaseUrl")
        }
        set(newValue) {
            userDefaults.setValue(newValue, forKey: "ApiStoreBaseUrl")
        }
    }
    
    var apiCredentialsAreSet: Bool {
        get {
            return self.apiUsername != nil && self.apiToken != nil && self.apiStoreBaseUrl != nil
        }
    }
    
    //Define a shared instance method to return a singleton of the manager
    public class var sharedInstance : DefaultsManager {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : DefaultsManager? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = DefaultsManager()
        }
        return Static.instance!
    }
}
