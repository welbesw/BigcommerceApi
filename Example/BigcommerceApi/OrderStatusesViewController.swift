//
//  OrderStatusesViewController.swift
//  BigcommerceApi
//
//  Created by William Welbes on 8/11/15.
//  Copyright (c) 2015 CocoaPods. All rights reserved.
//

import UIKit
import BigcommerceApi

class OrderStatusesViewController: UITableViewController {

    var orderStatuses:[BigcommerceOrderStatus] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Load the order statuses from the API
        BigcommerceApi.sharedInstance.getOrderStatuses { (orderStatuses, error) -> () in
            if(error == nil) {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.orderStatuses = orderStatuses
                    self.tableView.reloadData()
                })
            } else {
                let alert = UIAlertView(title: "Error", message: "Error loading statuses: \(error!.localizedDescription)", delegate: nil, cancelButtonTitle: "Ok")
                alert.show()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapDoneButton(sender: AnyObject?) {
        
        DefaultsManager.sharedInstance.orderStatusIdFilter = nil
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.orderStatuses.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("orderStatusCell", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...
        let orderStatus = self.orderStatuses[indexPath.row]
        
        cell.textLabel!.text = "\(orderStatus.id) - " + orderStatus.name

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //Use the selected row as the status filter
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let orderStatus = self.orderStatuses[indexPath.row]
        
        DefaultsManager.sharedInstance.orderStatusIdFilter = orderStatus.id
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
