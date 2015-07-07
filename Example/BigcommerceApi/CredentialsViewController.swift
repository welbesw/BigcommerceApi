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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCredentials()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadCredentials() {
        let defaultsManager = DefaultsManager.sharedInstance
        
        apiBaseUrlTextField.text = defaultsManager.apiStoreBaseUrl
        apiUsernameTextField.text = defaultsManager.apiUsername
        apiTokenTextField.text = defaultsManager.apiToken
    }
    
    @IBAction func didTapSaveButton() {
        //Store the credentials in NSUserDefaults
        
        dismissKeyboard()
        
        let defaultsManager = DefaultsManager.sharedInstance
        defaultsManager.apiStoreBaseUrl = apiBaseUrlTextField.text
        defaultsManager.apiUsername = apiUsernameTextField.text
        defaultsManager.apiToken = apiTokenTextField.text
        
        //Set the credentials on the BigcommerceApi instance
        if(defaultsManager.apiCredentialsAreSet) {
            BigcommerceApi.sharedInstance.setCredentials(defaultsManager.apiUsername!, token: defaultsManager.apiToken!, storeBaseUrl: defaultsManager.apiStoreBaseUrl!)
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func didTapCancelButton() {
        
        dismissKeyboard()
        
        //Close the view controller
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func dismissKeyboard() {
        apiUsernameTextField.resignFirstResponder()
        apiTokenTextField.resignFirstResponder()
        apiBaseUrlTextField.resignFirstResponder()
    }

}
