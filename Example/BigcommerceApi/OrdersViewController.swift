//
//  OrdersViewController.swift
//  BigcommerceApi
//
//  Created by William Welbes on 7/7/15.
//  Copyright (c) 2015 CocoaPods. All rights reserved.
//

import UIKit
import BigcommerceApi

class OrdersViewController: UITableViewController {

    var orders:[BigcommerceOrder] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Check if the API credentials have been set and present the view controller if they have note been set
        let defaultsManager = DefaultsManager.sharedInstance
        if !defaultsManager.apiCredentialsAreSet {
            self.performSegueWithIdentifier("ModalCredentialsSegue", sender: nil)
        } else {
            //Set the API credentials
            BigcommerceApi.sharedInstance.setCredentials(defaultsManager.apiUsername!, token: defaultsManager.apiToken!, storeBaseUrl: defaultsManager.apiStoreBaseUrl!)
            
            BigcommerceApi.sharedInstance.getOrders({ (orders, error) -> () in
                //Check for an error and load the orders
                if(error == nil) {
                    self.orders = orders
                    self.tableView.reloadData()
                } else {
                    println("Error loading orders: \(error!.localizedDescription)")
                }
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return orders.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("orderCell", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...
        let order = orders[indexPath.row]
        cell.textLabel!.text = order.orderId?.stringValue

        return cell
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
