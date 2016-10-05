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
                DispatchQueue.main.async {
                    self.orderStatuses = orderStatuses
                    self.tableView.reloadData()
                }
            } else {
                
                let alertController = UIAlertController(title: "Error", message: "Error loading statuses: \(error!.localizedDescription)", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapDoneButton(_ sender: AnyObject?) {
        
        DefaultsManager.sharedInstance.orderStatusIdFilter = nil
        
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.orderStatuses.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderStatusCell", for: indexPath) 

        // Configure the cell...
        let orderStatus = self.orderStatuses[indexPath.row]
        
        cell.textLabel!.text = "\(orderStatus.id) - " + orderStatus.name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Use the selected row as the status filter
        tableView.deselectRow(at: indexPath, animated: true)
        
        let orderStatus = self.orderStatuses[indexPath.row]
        
        DefaultsManager.sharedInstance.orderStatusIdFilter = orderStatus.id
        
        self.dismiss(animated: true, completion: nil)
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
