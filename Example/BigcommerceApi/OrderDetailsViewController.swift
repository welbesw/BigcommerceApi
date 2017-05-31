//
//  OrderDetailsViewController.swift
//  BigcommerceApi
//
//  Created by William Welbes on 7/8/15.
//  Copyright (c) 2015 CocoaPods. All rights reserved.
//

import UIKit
import BigcommerceApi

open class OrderDetailsViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    open var order:BigcommerceOrder!
    
    open override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        loadOrderDetails()
        
        loadOrderProducts()
        
        loadShippingAddresses()
        
        loadShipments()
        
        loadOrderMessages()
    }

    open override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadOrderDetails() {
        if let orderId = order.orderId?.stringValue {
            BigcommerceApi.sharedInstance.getOrder(orderId: orderId, completion: { (order, error) -> () in
                DispatchQueue.main.async(execute: { () -> Void in
                    if(error == nil && order != nil) {
                        print("Got order: \(order?.orderId ?? -1)")
                    } else {
                        print("Error getting order: \(error!.localizedDescription)")
                    }
                })
            })
        }
        
        self.textView.text = self.order.description
    }
    
    func loadOrderMessages() {
        if let orderId = order.orderId?.stringValue {
            BigcommerceApi.sharedInstance.getOrderMessages(orderId) { (orderMessages, error) -> () in
                DispatchQueue.main.async(execute: { () -> Void in
                    if(error == nil) {
                        for orderMessage in orderMessages {
                            print("Order Message: \(orderMessage.subject) - (\(orderMessage.message))")
                        }
                    } else {
                        print("Error getting order messages: \(error!.localizedDescription)")
                    }
                })
            }
        }
    }
    
    func loadOrderProducts() {
        BigcommerceApi.sharedInstance.getProductsForOrder(order, completion: { (orderProducts, error) -> () in
            //Check for error
            if(error == nil) {
                for orderProduct in orderProducts {
                    print("Order Product: \(orderProduct.name) - (\(orderProduct.quantity ?? 0))")
                    for productOption in orderProduct.productOptions {
                        print("Order Product Option: \(productOption.displayName) : \(productOption.displayValue)")
                    }
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
    override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "EditStatusSegue") {
            if let navController = segue.destination as? UINavigationController {
                if let updateStatusViewController = navController.topViewController as? UpdateStatusViewController {
                    updateStatusViewController.orderId = self.order.orderId!.stringValue
                }
            }
        }
    }

}
