//
//  OrderDetailsViewController.swift
//  BigcommerceApi
//
//  Created by William Welbes on 7/8/15.
//  Copyright (c) 2015 CocoaPods. All rights reserved.
//

import UIKit
import BigcommerceApi

public class OrderDetailsViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    public var order:BigcommerceOrder!
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        loadOrderDetails()
        
        loadOrderProducts()
        
        loadShippingAddresses()
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadOrderDetails() {
        self.textView.text = self.order.description
    }
    
    func loadOrderProducts() {
        BigcommerceApi.sharedInstance.getProductsForOrder(order, completion: { (orderProducts, error) -> () in
            //Check for error
            if(error == nil) {
                for orderProduct in orderProducts {
                    println("Order Product: \(orderProduct.name) - (\(orderProduct.quantity))")
                }
            } else {
                println("Error getting order products: \(error!.localizedDescription)")
            }
        })
    }
    
    func loadShippingAddresses() {
        BigcommerceApi.sharedInstance.getShippingAddressesForOrder(order, completion: { (orderShippingAddresses, error) -> () in
            if(error == nil) {
                for orderShippingAddress in orderShippingAddresses {
                    println("Order Shipping Address: \(orderShippingAddress.street1)")
                }
            } else {
                println("Error getting order shipping address: \(error!.localizedDescription)")
            }
        })
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
