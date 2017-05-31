//
//  ProductDetailsViewController.swift
//  BigcommerceApi
//
//  Created by William Welbes on 10/1/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import UIKit
import BigcommerceApi

class ProductDetailsViewController: UIViewController {

    @IBOutlet weak var textView:UITextView!
    
    var product:BigcommerceProduct!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        loadProductImages()
        loadProductSkus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.textView.text = product.description
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "ModalEditInventorySegue" {
            if let navController = segue.destination as? UINavigationController {
                if let editInventoryViewController = navController.topViewController as? EditInvetoryViewController {
                    editInventoryViewController.product = product
                }
            }
        }
    }
    
    func loadProductImages() {
        if let productId = product.productId?.stringValue {
            BigcommerceApi.sharedInstance.getProductImages(productId) { (productImages, error) -> () in
                if(error == nil) {
                    for productImage in productImages {
                        print("Loaded \(productImage.standardUrl ?? "") product images")
                    }
                }
            }
        }
    }
    
    func loadProductSkus() {
        if let productId = product.productId?.stringValue {
            BigcommerceApi.sharedInstance.getProductSkus(productId, completion: { (productSkus, error) in
                if(error == nil) {
                    for productSku in productSkus {
                        print("Loaded product sku: \(productSku.productSkuId?.stringValue ?? "")")
                    }
                }
            })
        }
    }

}
