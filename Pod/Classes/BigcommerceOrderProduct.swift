//
//  BigcommerceOrderProduct.swift
//  Pods
//
//  Created by William Welbes on 8/12/15.
//
//

import Foundation

open class BigcommerceOrderProduct: NSObject {

    open var id : NSNumber?
    
    open var name : String = ""
    
    open var baseCostPrice: NSNumber = 0.0
    open var basePrice: NSNumber = 0.0
    open var baseTotal: NSNumber = 0.0
    open var baseWrappingCost: NSNumber = 0.0
    
    open var binPickingNumber: String = ""
    
    open var costPriceExludingTax: NSNumber = 0.0
    open var costPriceIncludingTax: NSNumber = 0.0
    open var costPriceTax: NSNumber = 0.0
    
    open var ebayItemId: String = ""
    open var ebayTransactionId: String = ""
    
    open var eventDate: String = ""
    open var eventName: String = ""
    
    open var fixedShippingCost: NSNumber = 0.0
    
    open var isBundledProduct: NSNumber = false
    open var isRefunded: NSNumber = false
    
    open var optionSetId: String = ""
    open var orderAddressId: NSNumber?
    
    open var orderId: NSNumber?
    open var parentOrderProductId: NSNumber?
    
    open var priceExcludingTax: NSNumber = 0.0
    open var priceIncludingTax: NSNumber = 0.0
    open var priceTax: NSNumber = 0.0
    
    open var productId: NSNumber?
    open var quantity: NSNumber?
    open var quantityShipped: NSNumber?

    open var refundAmount: NSNumber = 0.0
    open var returnId: NSNumber?
    
    open var sku: String = ""
    
    open var totalExcludingTax: NSNumber = 0.0
    open var totalIncludingTax: NSNumber = 0.0
    open var totalTax: NSNumber = 0.0

    open var type: String?
    
    open var weight: NSNumber = 0.0
    open var wrappingCostExcludingTax: NSNumber = 0.0
    open var wrappingCostIncludingTax: NSNumber = 0.0
    open var wrappingCostTax: NSNumber = 0.0
    open var wrappingMessage: String = ""
    open var wrappingName: String = ""
    
    open var productOptions:[BigcommerceOrderProductOption] = []
    
    //Pass in the currency code from the order
    public init(jsonDictionary:NSDictionary, currencyLocale:Locale?) {
        //Load the JSON dictionary into the order object
        
        //Float values are returned as quote enclosed strings in the JSON from the API
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal

        numberFormatter.locale = currencyLocale
        
        if let id = jsonDictionary["id"] as? NSNumber {
            self.id = id
        }
        
        if let name = jsonDictionary["name"] as? String {
            self.name = name
        }
        
        if let stringValue = jsonDictionary["base_cost_price"] as? String {
            if let numberValue = numberFormatter.number(from: stringValue) {
                baseCostPrice = numberValue
            }
        }
        
        if let stringValue = jsonDictionary["base_price"] as? String {
            if let numberValue = numberFormatter.number(from: stringValue) {
                basePrice = numberValue
            }
        }
        
        if let stringValue = jsonDictionary["base_total"] as? String {
            if let numberValue = numberFormatter.number(from: stringValue) {
                baseTotal = numberValue
            }
        }

        if let stringValue = jsonDictionary["base_wrapping_cost"] as? String {
            if let numberValue = numberFormatter.number(from: stringValue) {
                baseWrappingCost = numberValue
            }
        }

        if let stringValue = jsonDictionary["bin_picking_number"] as? String {
            binPickingNumber = stringValue
        }
        
        if let stringValue = jsonDictionary["cost_price_ex_tax"] as? String {
            if let numberValue = numberFormatter.number(from: stringValue) {
                costPriceExludingTax = numberValue
            }
        }
        
        if let stringValue = jsonDictionary["cost_price_inc_tax"] as? String {
            if let numberValue = numberFormatter.number(from: stringValue) {
                costPriceIncludingTax = numberValue
            }
        }
        
        if let stringValue = jsonDictionary["cost_price_tax"] as? String {
            if let numberValue = numberFormatter.number(from: stringValue) {
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
            if let numberValue = numberFormatter.number(from: stringValue) {
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
            if let numberValue = numberFormatter.number(from: stringValue) {
                priceExcludingTax = numberValue
            }
        }
        if let stringValue = jsonDictionary["price_inc_tax"] as? String {
            if let numberValue = numberFormatter.number(from: stringValue) {
                priceIncludingTax = numberValue
            }
        }
        if let stringValue = jsonDictionary["price_tax"] as? String {
            if let numberValue = numberFormatter.number(from: stringValue) {
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
            if let numberValue = numberFormatter.number(from: stringValue) {
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
            if let numberValue = numberFormatter.number(from: stringValue) {
                totalExcludingTax = numberValue
            }
        }
        if let stringValue = jsonDictionary["total_inc_tax"] as? String {
            if let numberValue = numberFormatter.number(from: stringValue) {
                totalIncludingTax = numberValue
            }
        }
        if let stringValue = jsonDictionary["total_tax"] as? String {
            if let numberValue = numberFormatter.number(from: stringValue) {
                totalTax = numberValue
            }
        }
        
        if let stringValue = jsonDictionary["type"] as? String {
            type = stringValue
        }
        
        if let stringValue = jsonDictionary["weight"] as? String {
            if let numberValue = numberFormatter.number(from: stringValue) {
                weight = numberValue
            }
        }
        
        if let stringValue = jsonDictionary["wrapping_cost_ex_tax"] as? String {
            if let numberValue = numberFormatter.number(from: stringValue) {
                wrappingCostExcludingTax = numberValue
            }
        }
        if let stringValue = jsonDictionary["wrapping_cost_inc_tax"] as? String {
            if let numberValue = numberFormatter.number(from: stringValue) {
                wrappingCostIncludingTax = numberValue
            }
        }
        if let stringValue = jsonDictionary["wrapping_cost_tax"] as? String {
            if let numberValue = numberFormatter.number(from: stringValue) {
                wrappingCostTax = numberValue
            }
        }
        
        if let stringValue = jsonDictionary["wrapping_message"] as? String {
            wrappingMessage = stringValue
        }
        
        if let stringValue = jsonDictionary["wrapping_name"] as? String {
            wrappingName = stringValue
        }
        
        if let optionArray = jsonDictionary["product_options"] as? NSArray {
            for optionElement in optionArray {
                if let optionDict = optionElement as? NSDictionary {
                    let productOption = BigcommerceOrderProductOption(jsonDictionary: optionDict)
                    productOptions.append(productOption)
                }
            }
        }
    }
}
