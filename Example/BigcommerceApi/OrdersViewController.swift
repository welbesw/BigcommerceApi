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
            self.performSegue(withIdentifier: "ModalCredentialsSegue", sender: nil)
        } else {
            //Set the API credentials
            BigcommerceApi.sharedInstance.setCredentials(defaultsManager.apiUsername!, token: defaultsManager.apiToken!, storeBaseUrl: defaultsManager.apiStoreBaseUrl!)
            
            //Fetch the Bigcommerce store
            BigcommerceApi.sharedInstance.getStore({ (store, error) -> () in
                if error == nil && store != nil {
                    print("Loaded store: \(store?.name ?? ""), logo: \(store?.logoUrl ?? "")")
                } else {
                    print("Error loading store: \(error?.localizedDescription ?? "")")
                }
            })
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        reloadOrders()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadOrders() {
        if let orderStatusId = DefaultsManager.sharedInstance.orderStatusIdFilter {
            BigcommerceApi.sharedInstance.getOrdersWithStatus(orderStatusId, completion: { (orders, error) -> () in
                //Check for an error and load the orders
                if(error == nil) {
                    DispatchQueue.main.async {
                        self.orders = orders
                        self.tableView.reloadData()
                    }
                } else {
                    print("Error loading orders: \(error!.localizedDescription)")
                }
            })
            
        } else {
        
            BigcommerceApi.sharedInstance.getOrdersMostRecent({ (orders, error) -> () in
                //Check for an error and load the orders
                if(error == nil) {
                    DispatchQueue.main.async {
                        self.orders = orders
                        self.tableView.reloadData()
                    }
                } else {
                    print("Error loading orders: \(error!.localizedDescription)")
                }
            })
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return orders.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath) 

        // Configure the cell...
        let order = orders[indexPath.row]
        if let orderId = order.orderId {
            cell.textLabel!.text = "Order \(orderId.stringValue)"
        } else {
            cell.textLabel!.text = "Order (no id)"
        }

        return cell
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "OrderDetailsSegue" {
            if let orderDetailsViewController = segue.destination as? OrderDetailsViewController {
                //get the selected row
                if let selectedIndex = self.tableView.indexPathForSelectedRow {
                    let order = self.orders[selectedIndex.row]
                    orderDetailsViewController.order = order
                }
            }
        }
    }

}
