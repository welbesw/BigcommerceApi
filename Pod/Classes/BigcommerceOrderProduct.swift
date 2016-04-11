//
//  BigcommerceOrderProduct.swift
//  Pods
//
//  Created by William Welbes on 8/12/15.
//
//

import Foundation

public class BigcommerceOrderProduct: NSObject {

    public var id : NSNumber?
    
    public var name : String = ""
    
    public var baseCostPrice: NSNumber = 0.0
    public var basePrice: NSNumber = 0.0
    public var baseTotal: NSNumber = 0.0
    public var baseWrappingCost: NSNumber = 0.0
    
    public var binPickingNumber: String = ""
    
    public var costPriceExludingTax: NSNumber = 0.0
    public var costPriceIncludingTax: NSNumber = 0.0
    public var costPriceTax: NSNumber = 0.0
    
    public var ebayItemId: String = ""
    public var ebayTransactionId: String = ""
    
    public var eventDate: String = ""
    public var eventName: String = ""
    
    public var fixedShippingCost: NSNumber = 0.0
    
    public var isBundledProduct: NSNumber = false
    public var isRefunded: NSNumber = false
    
    public var optionSetId: String = ""
    public var orderAddressId: NSNumber?
    
    public var orderId: NSNumber?
    public var parentOrderProductId: NSNumber?
    
    public var priceExcludingTax: NSNumber = 0.0
    public var priceIncludingTax: NSNumber = 0.0
    public var priceTax: NSNumber = 0.0
    
    public var productId: NSNumber?
    public var quantity: NSNumber?
    public var quantityShipped: NSNumber?

    public var refundAmount: NSNumber = 0.0
    public var returnId: NSNumber?
    
    public var sku: String = ""
    
    public var totalExcludingTax: NSNumber = 0.0
    public var totalIncludingTax: NSNumber = 0.0
    public var totalTax: NSNumber = 0.0

    public var type: String?
    
    public var weight: NSNumber = 0.0
    public var wrappingCostExcludingTax: NSNumber = 0.0
    public var wrappingCostIncludingTax: NSNumber = 0.0
    public var wrappingCostTax: NSNumber = 0.0
    public var wrappingMessage: String = ""
    public var wrappingName: String = ""
    
    
    public init(jsonDictionary:NSDictionary) {
        //Load the JSON dictionary into the order object
        
        //Float values are returned as quote enclosed strings in the JSON from the API
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        
        if let id = jsonDictionary["id"] as? NSNumber {
            self.id = id
        }
        
        if let name = jsonDictionary["name"] as? String {
            self.name = name
        }
        
        if let stringValue = jsonDictionary["base_cost_price"] as? String {
            if let numberValue = numberFormatter.numberFromString(stringValue) {
                baseCostPrice = numberValue
            }
        }
        
        if let stringValue = jsonDictionary["base_price"] as? String {
            if let numberValue = numberFormatter.numberFromString(stringValue) {
                basePrice = numberValue
            }
        }
        
        if let stringValue = jsonDictionary["base_total"] as? String {
            if let numberValue = numberFormatter.numberFromString(stringValue) {
                baseTotal = numberValue
            }
        }

        if let stringValue = jsonDictionary["base_wrapping_cost"] as? String {
            if let numberValue = numberFormatter.numberFromString(stringValue) {
                baseWrappingCost = numberValue
            }
        }

        if let stringValue = jsonDictionary["bin_picking_number"] as? String {
            binPickingNumber = stringValue
        }
        
        if let stringValue = jsonDictionary["cost_price_ex_tax"] as? String {
            if let numberValue = numberFormatter.numberFromString(stringValue) {
                costPriceExludingTax = numberValue
            }
        }
        
        if let stringValue = jsonDictionary["cost_price_inc_tax"] as? String {
            if let numberValue = numberFormatter.numberFromString(stringValue) {
                costPriceIncludingTax = numberValue
            }
        }
        
        if let stringValue = jsonDictionary["cost_price_tax"] as? String {
            if let numberValue = numberFormatter.numberFromString(stringValue) {
                costPriceTax = numberValue
            }
        }
        
        if let stringValue = jsonDictionary["ebay_item_id"] as? String {
            self.ebayItemId = stringValue
        }
        if let stringValue = jsonDictionary["ebay_transaction_id"] as? String {
            self.ebayTransactionId = stringValue
        }
        
        if let stringValue = jsonDictionary["event_date"] as? String {
            self.eventDate = stringValue
        }
        if let stringValue = jsonDictionary["event_name"] as? String {
            self.eventName = stringValue
        }
        
        if let stringValue = jsonDictionary["fixed_shipping_cost"] as? String {
            if let numberValue = numberFormatter.numberFromString(stringValue) {
                fixedShippingCost = numberValue
            }
        }
        
        if let numberValue = jsonDictionary["is_bundled_product"] as? NSNumber {
            self.isBundledProduct = numberValue
        }
        if let numberValue = jsonDictionary["is_refunded"] as? NSNumber {
            self.isRefunded = numberValue
        }
        
        if let stringValue = jsonDictionary["option_set_id"] as? String {
            self.optionSetId = stringValue
        }
        if let numberValue = jsonDictionary["order_address_id"] as? NSNumber {
            self.orderAddressId = numberValue
        }
        
        if let numberValue = jsonDictionary["order_id"] as? NSNumber {
            self.orderId = numberValue
        }
        if let numberValue = jsonDictionary["parent_order_product_id"] as? NSNumber {
            self.parentOrderProductId = numberValue
        }
        
        if let stringValue = jsonDictionary["price_ex_tax"] as? String {
            if let numberValue = numberFormatter.numberFromString(stringValue) {
                priceExcludingTax = numberValue
            }
        }
        if let stringValue = jsonDictionary["price_inc_tax"] as? String {
            if let numberValue = numberFormatter.numberFromString(stringValue) {
                priceIncludingTax = numberValue
            }
        }
        if let stringValue = jsonDictionary["price_tax"] as? String {
            if let numberValue = numberFormatter.numberFromString(stringValue) {
                priceTax = numberValue
            }
        }
        
        if let numberValue = jsonDictionary["product_id"] as? NSNumber {
            self.productId = numberValue
        }
        if let numberValue = jsonDictionary["quantity"] as? NSNumber {
            self.quantity = numberValue
        }
        if let numberValue = jsonDictionary["quantity_shipped"] as? NSNumber {
            self.quantityShipped = numberValue
        }
        
        if let stringValue = jsonDictionary["refund_amount"] as? String {
            if let numberValue = numberFormatter.numberFromString(stringValue) {
                refundAmount = numberValue
            }
        }
        if let numberValue = jsonDictionary["return_id"] as? NSNumber {
            self.returnId = numberValue
        }
        
        if let stringValue = jsonDictionary["sku"] as? String {
            sku = stringValue
        }
        
        if let stringValue = jsonDictionary["total_ex_tax"] as? String {
            if let numberValue = numberFormatter.numberFromString(stringValue) {
                totalExcludingTax = numberValue
            }
        }
        if let stringValue = jsonDictionary["total_inc_tax"] as? String {
            if let numberValue = numberFormatter.numberFromString(stringValue) {
                totalIncludingTax = numberValue
            }
        }
        if let stringValue = jsonDictionary["total_tax"] as? String {
            if let numberValue = numberFormatter.numberFromString(stringValue) {
                totalTax = numberValue
            }
        }
        
        if let stringValue = jsonDictionary["type"] as? String {
            type = stringValue
        }
        
        if let stringValue = jsonDictionary["weight"] as? String {
            if let numberValue = numberFormatter.numberFromString(stringValue) {
                weight = numberValue
            }
        }
        
        if let stringValue = jsonDictionary["wrapping_cost_ex_tax"] as? String {
            if let numberValue = numberFormatter.numberFromString(stringValue) {
                wrappingCostExcludingTax = numberValue
            }
        }
        if let stringValue = jsonDictionary["wrapping_cost_inc_tax"] as? String {
            if let numberValue = numberFormatter.numberFromString(stringValue) {
                wrappingCostIncludingTax = numberValue
            }
        }
        if let stringValue = jsonDictionary["wrapping_cost_tax"] as? String {
            if let numberValue = numberFormatter.numberFromString(stringValue) {
                wrappingCostTax = numberValue
            }
        }
        
        if let stringValue = jsonDictionary["wrapping_message"] as? String {
            wrappingMessage = stringValue
        }
        
        if let stringValue = jsonDictionary["wrapping_name"] as? String {
            wrappingName = stringValue
        }
    }
}