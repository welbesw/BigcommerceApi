//
//  BigcommerceApi.swift
//  
//
//  Created by William Welbes on 6/22/15.
//
//

import Foundation
import Alamofire

public class BigcommerceApi: NSObject {
    
    var apiUsername = ""            //Pass in via setCredentials
    var apiToken = ""               //Pass in via setCredentials
    var apiStoreBaseUrl = ""        //Pass in via setCredentials
    
    var alamofireManager: Alamofire.Manager!
    
    //Define a shared instance method to return a singleton of the API manager
    public class var sharedInstance : BigcommerceApi {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : BigcommerceApi? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = BigcommerceApi()
        }
        return Static.instance!
    }
    
    override init() {
        super.init()
        
        initializeAlamofire()
    }
    
    public init(username: String, token: String, storeBaseUrl: String) {
        super.init()
        
        setCredentials(username, token: token, storeBaseUrl: storeBaseUrl)
        
        initializeAlamofire()
    }
    
    func initializeAlamofire() {
        var defaultHeaders = Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders ?? [:]
        defaultHeaders["Accept"] = "application/json"
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = defaultHeaders
        
        self.alamofireManager = Alamofire.Manager(configuration: configuration)
    }
    
    //Set the credentials to use with the API
    public func setCredentials(username: String, token: String, storeBaseUrl: String) {
        self.apiUsername = username
        self.apiToken = token
        self.apiStoreBaseUrl = storeBaseUrl
    }
    
    public func getOrdersMostRecent(completion: (orders:[BigcommerceOrder], error: NSError?) -> ()) {
        
        let parameters = ["sort" : "date_created:desc", "limit": "50"]
        getOrders(parameters, completion: completion)
    }
    
    public func getOrdersWithStatus(statusId:Int, completion: (orders:[BigcommerceOrder], error: NSError?) -> ()) {
        
        let parameters = ["sort" : "date_created:desc", "limit": "50", "status_id" : String(statusId)]
        getOrders(parameters, completion: completion)
    }
    
    //Retrieve an array of Bigcommerce order objects
    func getOrders(parameters:[String : String], completion: (orders:[BigcommerceOrder], error: NSError?) -> ()) {
        
        alamofireManager.request(.GET, apiStoreBaseUrl + "orders", parameters:parameters)
            .authenticate(user: apiUsername, password: apiToken)
            .responseJSON { (request, response, result) in
                
                if(result.isSuccess) {
                    
                    var orders: [BigcommerceOrder] = []
                    
                    //Loop over the orders JSON object and create order objects for each one
                    if let ordersArray = result.value as? NSArray {
                        for orderElement in ordersArray {
                            if let orderDict = orderElement as? NSDictionary {
                                let order = BigcommerceOrder(jsonDictionary: orderDict)
                                orders.append(order)
                            }
                        }
                    }
                    
                    completion(orders: orders, error: nil)
                    
                    
                } else {
                    print(result.error)
                    completion(orders: [], error: result.error as? NSError)
                }
        }
    }
    
    public func getOrder(orderId orderId: String, completion: (order:BigcommerceOrder?, error: NSError?) -> ()) {
        
        alamofireManager.request(.GET, apiStoreBaseUrl + "order/\(orderId)", parameters:nil)
            .authenticate(user: apiUsername, password: apiToken)
            .responseJSON { (request, response, result) in
                
                if(result.isSuccess) {
                    
                    var order:BigcommerceOrder? = nil
                    
                    if let orderDict = result.value as? NSDictionary {
                        order = BigcommerceOrder(jsonDictionary: orderDict)
                    }
                    
                    completion(order: order, error: nil)
                    
                    
                } else {
                    print(result.error)
                    completion(order: nil, error: result.error as? NSError)
                }
        }
    }
    
    public func updateOrderStatus(orderId:String, newStatusId:Int, completion: (error: NSError?) -> ()) {
        
        let parameters = ["status_id" : newStatusId]
        
        alamofireManager.request(.PUT, apiStoreBaseUrl + "orders/\(orderId)", parameters:parameters, encoding:.JSON)
            .authenticate(user: apiUsername, password: apiToken)
            .responseJSON { (request, response, result) in
                
                if(result.isSuccess) {
                    
                    completion(error: nil)
                    
                    
                } else {
                    print(result.error)
                    completion(error: result.error as? NSError)
                }
        }
    }
    
    public func getProductsForOrder(order:BigcommerceOrder, completion: (orderProducts:[BigcommerceOrderProduct], error: NSError?) -> ()) {
        //Use the resource specified in the order to fetch the products
        
        if order.productsUrl.characters.count > 0 {
        
            alamofireManager.request(.GET, order.productsUrl, parameters:nil)
                .authenticate(user: apiUsername, password: apiToken)
                .responseJSON { (request, response, result) in
                    
                    if(result.isSuccess) {
                        
                        var orderProducts: [BigcommerceOrderProduct] = []
                        
                        //Loop over the orders JSON object and create order objects for each one
                        if let orderProductsArray = result.value as? NSArray {
                            for orderProductElement in orderProductsArray {
                                if let productDict = orderProductElement as? NSDictionary {
                                    let orderProduct = BigcommerceOrderProduct(jsonDictionary: productDict)
                                    orderProducts.append(orderProduct)
                                }
                            }
                        }
                        
                        completion(orderProducts: orderProducts, error: nil)
                        
                        
                    } else {
                        print(result.error)
                        completion(orderProducts: [], error: result.error as? NSError)
                    }
            }
        } else {
            let error = NSError(domain: "com.technomagination.BigcommerceApi", code: 1, userInfo: nil)
            completion(orderProducts: [], error: error)
        }
    }
    
    public func getShippingAddressesForOrder(order:BigcommerceOrder, completion: (orderShippingAddresses:[BigcommerceOrderShippingAddress], error: NSError?) -> ()) {
        //Use the resource specified in the order to fetch the products
        
        if order.shippingAddressesUrl.characters.count > 0 {
            
            alamofireManager.request(.GET, order.shippingAddressesUrl, parameters:nil)
                .authenticate(user: apiUsername, password: apiToken)
                .responseJSON { (request, response, result) in
                    
                    if(result.isSuccess) {
                        
                        var orderShippingAddresses: [BigcommerceOrderShippingAddress] = []
                        
                        //Loop over the orders JSON object and create order objects for each one
                        if let orderShippingAddressesArray = result.value as? NSArray {
                            for orderShippingAddressElement in orderShippingAddressesArray {
                                if let shippingAddressDict = orderShippingAddressElement as? NSDictionary {
                                    let orderShippingAddress = BigcommerceOrderShippingAddress(jsonDictionary: shippingAddressDict)
                                    orderShippingAddresses.append(orderShippingAddress)
                                }
                            }
                        }
                        
                        completion(orderShippingAddresses: orderShippingAddresses, error: nil)
                        
                        
                    } else {
                        print(result.error)
                        completion(orderShippingAddresses: [], error: result.error as? NSError)
                    }
            }
        } else {
            let error = NSError(domain: "com.technomagination.BigcommerceApi", code: 2, userInfo: nil)
            completion(orderShippingAddresses: [], error: error)
        }
    }
    
    public func getOrderStatuses(completion: (orderStatuses:[BigcommerceOrderStatus], error: NSError?) -> ()) {
        alamofireManager.request(.GET, apiStoreBaseUrl + "order_statuses", parameters:nil)
            .authenticate(user: apiUsername, password: apiToken)
            .responseJSON { (request, response, result) in
                
                var orderStatuses:[BigcommerceOrderStatus] = []
                
                if(result.isSuccess) {
                    
                    //Loop over the orders JSON object and create order objects for each one
                    if let orderStatusArray = result.value as? NSArray {
                        for orderStatusElement in orderStatusArray {
                            if let orderStatusDict = orderStatusElement as? NSDictionary {
                                let orderStatus = BigcommerceOrderStatus(jsonDictionary: orderStatusDict)
                                orderStatuses.append(orderStatus)
                            }
                        }
                    }
                    
                    orderStatuses.sortInPlace({ $0.id < $1.id })
                    
                    completion(orderStatuses: orderStatuses, error: nil)
                    
                    
                } else {
                    print(result.error)
                    completion(orderStatuses: orderStatuses, error: result.error as? NSError)
                }
        }
    }
    
    public func getProducts(completion: (products:[BigcommerceProduct], error: NSError?) -> ()) {
        //let parameters = ["sort" : "date_created:desc", "limit": "50"]
        getProducts(nil, completion: completion)
    }
    
    public func getProducts(parameters:[String : String]?, completion: (products:[BigcommerceProduct], error: NSError?) -> ())  {
        alamofireManager.request(.GET, apiStoreBaseUrl + "products", parameters:parameters)
            .authenticate(user: apiUsername, password: apiToken)
            .responseJSON { (request, response, result) in
                
                if(result.isSuccess) {
                    
                    var products: [BigcommerceProduct] = []
                    
                    //Loop over the orders JSON object and create order objects for each one
                    if let productsArray = result.value as? NSArray {
                        for productElement in productsArray {
                            if let productDict = productElement as? NSDictionary {
                                let product = BigcommerceProduct(jsonDictionary: productDict)
                                products.append(product)
                            }
                        }
                    }
                    
                    completion(products: products, error: nil)
                    
                    
                } else {
                    print(result.error)
                    completion(products: [], error: result.error as? NSError)
                }
        }
    }
}
