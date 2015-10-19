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
        
        loadShipments()
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadOrderDetails() {
        if let orderId = order.orderId?.stringValue {
            BigcommerceApi.sharedInstance.getOrder(orderId: orderId, completion: { (order, error) -> () in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if(error == nil && order != nil) {
                        print("Got order: \(order!.orderId)")
                    } else {
                        print("Error getting order: \(error!.localizedDescription)")
                    }
                })
            })
        }
        
        self.textView.text = self.order.description
    }
    
    func loadOrderProducts() {
        BigcommerceApi.sharedInstance.getProductsForOrder(order, completion: { (orderProducts, error) -> () in
            //Check for error
            if(error == nil) {
                for orderProduct in orderProducts {
                    print("Order Product: \(orderProduct.name) - (\(orderProduct.quantity))")
                }
            } else {
                print("Error getting order products: \(error!.localizedDescription)")
            }
        })
    }
    
    func loadShippingAddresses() {
        BigcommerceApi.sharedInstance.getShippingAddressesForOrder(order, completion: { (orderShippingAddresses, error) -> () in
            if(error == nil) {
                for orderShippingAddress in orderShippingAddresses {
                    print("Order Shipping Address: \(orderShippingAddress.street1)")
                }
            } else {
                print("Error getting order shipping address: \(error!.localizedDescription)")
            }
        })
    }
    
    func loadShipments() {
        BigcommerceApi.sharedInstance.getShipmentsForOrder(order) { (orderShipments, error) -> () in
            if(error == nil) {
                for orderShipment in orderShipments {
                    print("Order Shipment: \(orderShipment.shippingMethod) - \(orderShipment.trackingNumber)")
                }
            } else {
                print("Error getting order shipping address: \(error!.localizedDescription)")
            }
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "EditStatusSegue") {
            if let navController = segue.destinationViewController as? UINavigationController {
                if let updateStatusViewController = navController.topViewController as? UpdateStatusViewController {
                    updateStatusViewController.orderId = self.order.orderId!.stringValue
                }
            }
        }
    }

}
