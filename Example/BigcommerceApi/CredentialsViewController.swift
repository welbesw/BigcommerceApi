//
//  CredentialsViewController.swift
//  BigcommerceApi
//
//  Created by William Welbes on 7/7/15.
//  Copyright (c) 2015 CocoaPods. All rights reserved.
//

import UIKit
import BigcommerceApi

class CredentialsViewController: UITableViewController {

    @IBOutlet var apiUsernameTextField: UITextField!
    @IBOutlet var apiTokenTextField: UITextField!
    @IBOutlet var apiBaseUrlTextField: UITextField!

    @IBOutlet var authModeSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        authModeSegmentedControl.addTarget(self, action: #selector(authModeDidChange), for: .valueChanged)

        loadCredentials()
        updatePlaceholders()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func authModeDidChange() {
        updatePlaceholders()
    }

    func updatePlaceholders() {
        apiUsernameTextField.placeholder = isOauthSelected ? "API Oauth Client ID" : "API Username"
        apiTokenTextField.placeholder = isOauthSelected ? "API Oauth Access Token" : "API Token"
    }

    var isOauthSelected: Bool {
        return authModeSegmentedControl.selectedSegmentIndex == 0
    }
    
    func loadCredentials() {
        let defaultsManager = DefaultsManager.sharedInstance

        switch defaultsManager.apiAuthMode {
        case .basic:
            apiBaseUrlTextField.text = defaultsManager.apiStoreBaseUrl
            apiUsernameTextField.text = defaultsManager.apiUsername
            apiTokenTextField.text = defaultsManager.apiToken
        case .oauth:
            apiBaseUrlTextField.text = defaultsManager.apiStoreBaseUrl
            apiUsernameTextField.text = defaultsManager.apiOauthId
            apiTokenTextField.text = defaultsManager.apiOauthToken
        }

    }
    
    @IBAction func didTapSaveButton() {
        //Store the credentials in NSUserDefaults
        
        dismissKeyboard()
        
        let defaultsManager = DefaultsManager.sharedInstance

        if isOauthSelected {
            defaultsManager.apiAuthMode = .oauth
            defaultsManager.apiStoreBaseUrl = apiBaseUrlTextField.text
            defaultsManager.apiOauthId = apiUsernameTextField.text
            defaultsManager.apiOauthToken = apiTokenTextField.text
        } else {
            defaultsManager.apiAuthMode = .basic
            defaultsManager.apiStoreBaseUrl = apiBaseUrlTextField.text
            defaultsManager.apiUsername = apiUsernameTextField.text
            defaultsManager.apiToken = apiTokenTextField.text
        }
        
        //Set the credentials on the BigcommerceApi instance
        if(defaultsManager.apiCredentialsAreSet) {
            switch defaultsManager.apiAuthMode {
            case .basic:
                BigcommerceApi.sharedInstance.setCredentials(defaultsManager.apiUsername!, token: defaultsManager.apiToken!, storeBaseUrl: defaultsManager.apiStoreBaseUrl!)
            default:
                BigcommerceApi.sharedInstance.setCredentialsOauth(clientId: defaultsManager.apiOauthId!, accessToken: defaultsManager.apiOauthToken!, storeBaseUrl: defaultsManager.apiStoreBaseUrl!)
            }

            
            //Attempt to get the store
            BigcommerceApi.sharedInstance.getStore({ (store, error) in
                DispatchQueue.main.async(execute: { 
                    if(error == nil) {
                        //TODO - set currency code for the store
                        if store != nil && store!.currency.count > 0 {
                            BigcommerceApi.sharedInstance.currencyCode = store!.currency
                        }
                        
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        let alert = UIAlertController(title: "Error Getting Store", message: error!.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                })
            })
        }
        
        
    }
    
    @IBAction func didTapCancelButton() {
        
        dismissKeyboard()
        
        //Close the view controller
        self.dismiss(animated: true, completion: nil)
    }

    func dismissKeyboard() {
        apiUsernameTextField.resignFirstResponder()
        apiTokenTextField.resignFirstResponder()
        apiBaseUrlTextField.resignFirstResponder()
    }

}
