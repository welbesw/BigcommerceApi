//
//  CustomerDetailsViewController.swift
//  BigcommerceApi
//
//  Created by William Welbes on 10/12/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import UIKit
import BigcommerceApi

public class CustomerDetailsViewController: UIViewController {

    @IBOutlet weak var textView:UITextView!
    
    public var customer:BigcommerceCustomer!
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadCustomerAddresses()
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.textView.text = customer.description
    }
    
    func loadCustomerAddresses() {
        if let customerId = self.customer.customerId {
            BigcommerceApi.sharedInstance.getCustomerAddresses(customerId.stringValue, completion: { (customerAddresses, error) -> () in
                //Added the addresses into the description
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    for address in customerAddresses {
                        self.textView.text = self.textView.text + "\n" + address.description
                    }
                })
            })
        }
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
