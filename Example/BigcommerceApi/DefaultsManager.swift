//
//  DefaultsManager.swift
//  BigcommerceApi
//
//  Created by William Welbes on 7/7/15.
//  Copyright (c) 2015 CocoaPods. All rights reserved.
//

import UIKit
import BigcommerceApi

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

    var apiOauthId: String? {
        get {
            return userDefaults.string(forKey: "ApiOauthId")
        }
        set(newValue) {
            userDefaults.setValue(newValue, forKey: "ApiOauthId")
        }
    }

    var apiOauthToken: String? {
        get {
            return userDefaults.string(forKey: "apiOauthToken")
        }
        set(newValue) {
            userDefaults.setValue(newValue, forKey: "apiOauthToken")
        }
    }

    var apiAuthMode: AuthMode {
        get {
            var authMode: AuthMode = .basic
            if let stringValue = userDefaults.string(forKey: "apiAuthMode"), let mode = AuthMode(rawValue: stringValue) {
                authMode = mode
            }
            return authMode
        }
        set(newValue) {
            userDefaults.setValue(newValue.rawValue, forKey: "apiAuthMode")
        }
    }

    var apiCredentialsAreSet: Bool {
        get {
            var credentialsSet = false
            switch apiAuthMode {
            case .basic:
                credentialsSet = apiUsername != nil && apiToken != nil && apiStoreBaseUrl != nil
            case .oauth:
                credentialsSet = apiOauthId != nil && apiOauthToken != nil && apiStoreBaseUrl != nil
            }
            return credentialsSet
        }
    }
}
