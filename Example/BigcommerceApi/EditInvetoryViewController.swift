//
//  EditInvetoryViewController.swift
//  BigcommerceApi
//
//  Created by William Welbes on 10/1/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import UIKit
import BigcommerceApi

class EditInvetoryViewController: UIViewController {

    @IBOutlet weak var textField:UITextField!
    
    var product:BigcommerceProduct!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let inventoryLevel = product.inventoryLevel {
            self.textField.text = inventoryLevel.stringValue
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func didTapSaveButton() {
        
        if let newLevelString = self.textField.text {
            if let newLevel = Int(newLevelString) {
                
                if let productIdString = self.product.productId?.stringValue {
                    BigcommerceApi.sharedInstance.updateProductInventory(productIdString, newInventoryLevel: newLevel, completion: { (error) -> () in
                        //Handle error
                        if(error == nil) {
                            self.product.inventoryLevel = NSNumber(integer: newLevel)
                            self.dismissViewControllerAnimated(true, completion: nil)
                        } else {
                            print("Error updating inventory level: \(error!.localizedDescription)")
                        }
                    })
                }
            }
        }
        
        
    }
    
    @IBAction func didTapCancelButton() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
