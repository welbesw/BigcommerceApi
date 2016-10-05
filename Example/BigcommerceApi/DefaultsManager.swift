//
//  DefaultsManager.swift
//  BigcommerceApi
//
//  Created by William Welbes on 7/7/15.
//  Copyright (c) 2015 CocoaPods. All rights reserved.
//

import UIKit

open class DefaultsManager: NSObject {
   
    //Define a shared instance method to return a singleton of the manager
    static let sharedInstance = DefaultsManager()
    
    let userDefaults = UserDefaults.standard
    
    var orderStatusIdFilter: Int? = nil //Allows the user to filter based on a specific order status
    
    var apiUsername: String? {
        get {
            return userDefaults.string(forKey: "ApiUsername")
        }
        set(newValue) {
            userDefaults.setValue(newValue, forKey: "ApiUsername")
        }
    }
    
    var apiToken: String? {
        get {
            return userDefaults.string(forKey: "ApiToken")
        }
        set(newValue) {
            userDefaults.setValue(newValue, forKey: "ApiToken")
        }
    }
    
    var apiStoreBaseUrl: String? {
        get {
            return userDefaults.string(forKey: "ApiStoreBaseUrl")
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
}
