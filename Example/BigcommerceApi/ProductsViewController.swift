//
//  ProductsViewController.swift
//  BigcommerceApi
//
//  Created by William Welbes on 9/30/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import UIKit
import BigcommerceApi

class ProductsViewController: UITableViewController {

    var products:[BigcommerceProduct] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        /*
        BigcommerceApi.sharedInstance.getProductsWithSku("W1234556") { (products, error) -> () in
            //Check for error
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if(error == nil) {
                    self.products = products
                    self.tableView.reloadData()
                } else {
                    print("Error getting products: \(error!.localizedDescription)")
                }
            })
        }
        */
        
        
        BigcommerceApi.sharedInstance.getProductsWithKeyword("sample") { (products, error) -> () in
            //Check for error
            DispatchQueue.main.async(execute: { () -> Void in
                if(error == nil) {
                    self.products = products
                    self.tableView.reloadData()
                } else {
                    print("Error getting products: \(error!.localizedDescription)")
                }
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of rows
        return self.products.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath)

        // Configure the cell...
        let product = self.products[indexPath.row]
        cell.textLabel!.text = product.name

        return cell
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "ProductDetailsSegue") {
            if let selectedIndex = self.tableView.indexPathForSelectedRow {
                let product = self.products[selectedIndex.row]
                
                if let productDetailsViewController = segue.destination as? ProductDetailsViewController {
                    productDetailsViewController.product = product
                }
            }
        }
    }

}
