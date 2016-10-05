//
//  CustomersViewController.swift
//  BigcommerceApi
//
//  Created by William Welbes on 10/12/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import UIKit
import BigcommerceApi

class CustomersViewController: UITableViewController {

    var customers:[BigcommerceCustomer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCustomers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadCustomers() {
        BigcommerceApi.sharedInstance.getCustomers(page:1, limit: 50) { (customers, error) in
            //Load the cusotmers
            DispatchQueue.main.async(execute: { () -> Void in
                //Check for error
                if(error == nil) {
                    self.customers = customers
                    self.tableView.reloadData()
                } else {
                    print("Error getting customers: \(error!.localizedDescription)")
                }
            })
        }
        /*
        BigcommerceApi.sharedInstance.getCustomers { (customers, error) -> () in
            //Load the cusotmers
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                //Check for error
                if(error == nil) {
                    self.customers = customers
                    self.tableView.reloadData()
                } else {
                    print("Error getting customers: \(error!.localizedDescription)")
                }
            })
        }*/
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of rows
        return customers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customerCell", for: indexPath)

        // Configure the cell...
        let customer = self.customers[indexPath.row]
        
        cell.textLabel!.text = "\(customer.firstName) \(customer.lastName)"

        return cell
    }


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if(segue.identifier == "PushCustomerDetailsSegue") {
            if let customerDetailsViewController = segue.destination as? CustomerDetailsViewController {
                    
                if let selectedIndex = self.tableView.indexPathForSelectedRow {
                    let customer = self.customers[selectedIndex.row]
                    
                    customerDetailsViewController.customer = customer
                }
            }
        }
    }

}
