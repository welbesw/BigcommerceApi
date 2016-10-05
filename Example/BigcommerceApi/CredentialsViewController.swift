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
            
            //Attempt to get the store
            BigcommerceApi.sharedInstance.getStore({ (store, error) in
                DispatchQueue.main.async(execute: { 
                    if(error == nil) {
                        //TODO - set currency code for the store
                        if store != nil && store!.currency.characters.count > 0 {
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
