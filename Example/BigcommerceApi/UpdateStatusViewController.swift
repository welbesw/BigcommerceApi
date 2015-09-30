//
//  UpdateStatusViewController.swift
//  BigcommerceApi
//
//  Created by William Welbes on 9/30/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import UIKit
import BigcommerceApi

class UpdateStatusViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    var orderId:String?
    var orderStatuses:[BigcommerceOrderStatus] = []
    
    @IBOutlet var statusPickerView:UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadStatuses()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadStatuses() {
        BigcommerceApi.sharedInstance.getOrderStatuses { (orderStatuses, error) -> () in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if(error == nil) {
                    self.orderStatuses = orderStatuses
                    self.statusPickerView.reloadAllComponents()
                } else {
                    print("Error loading statuses: \(error!.localizedDescription)")
                }
            })
        }
    }
    
    @IBAction func didTapCancelButton(sender:AnyObject?) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func didTapSaveButton(sender:AnyObject?) {
        
        if let orderId = self.orderId {
            
            //Get the selected status
            let selectedRow = self.statusPickerView.selectedRowInComponent(0)
            let orderStatus = self.orderStatuses[selectedRow]
            
            //Call save on the API
            BigcommerceApi.sharedInstance.updateOrderStatus(orderId, newStatusId: orderStatus.id, completion: { (error) -> () in
                //Check for error
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if(error != nil) {
                        print("Error updating status: \(error!.localizedDescription)")
                    } else {
                        print("Updated status.")
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                })
            })
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
        
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.orderStatuses.count
    }
    
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let orderStatus = self.orderStatuses[row]
        
        return orderStatus.name
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
