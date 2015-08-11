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
    
    //Retrieve an array of Bigcommerce order objects
    public func getOrders(completion: (orders:[BigcommerceOrder], error: NSError?) -> ()) {
        
        let parameters = ["sort" : "date_created:desc", "limit": "50"]
        
        alamofireManager.request(.GET, apiStoreBaseUrl + "orders", parameters:parameters)
            .authenticate(user: apiUsername, password: apiToken)
            .responseJSON { (request, response, JSON, error) in
                
                if(error == nil) {
                    
                    var orders: [BigcommerceOrder] = []
                    
                    //Loop over the orders JSON object and create order objects for each one
                    if let ordersArray = JSON as? NSArray {
                        for orderElement in ordersArray {
                            if let orderDict = orderElement as? NSDictionary {
                                let order = BigcommerceOrder(jsonDictionary: orderDict)
                                orders.append(order)
                            }
                        }
                    }
                    
                    completion(orders: orders, error: nil)
                    
                    
                } else {
                    println(error)
                    completion(orders: [], error: error)
                }
            }
    }
    
    public func getOrder(#orderId: String, completion: (order:BigcommerceOrder?, error: NSError?) -> ()) {
        
        alamofireManager.request(.GET, apiStoreBaseUrl + "order/\(orderId)", parameters:nil)
            .authenticate(user: apiUsername, password: apiToken)
            .responseJSON { (request, response, JSON, error) in
                
                if(error == nil) {
                    
                    var order:BigcommerceOrder? = nil
                    
                    if let orderDict = JSON as? NSDictionary {
                        let order = BigcommerceOrder(jsonDictionary: orderDict)
                    }
                    
                    completion(order: order, error: nil)
                    
                    
                } else {
                    println(error)
                    completion(order: nil, error: error)
                }
        }
    }
    
    public func getOrderStatuses(completion: (orderStatuses:[BigcommerceOrderStatus], error: NSError?) -> ()) {
        alamofireManager.request(.GET, apiStoreBaseUrl + "order_statuses", parameters:nil)
            .authenticate(user: apiUsername, password: apiToken)
            .responseJSON { (request, response, JSON, error) in
                
                var orderStatuses:[BigcommerceOrderStatus] = []
                
                if(error == nil) {
                    
                    //Loop over the orders JSON object and create order objects for each one
                    if let orderStatusArray = JSON as? NSArray {
                        for orderStatusElement in orderStatusArray {
                            if let orderStatusDict = orderStatusElement as? NSDictionary {
                                let orderStatus = BigcommerceOrderStatus(jsonDictionary: orderStatusDict)
                                orderStatuses.append(orderStatus)
                            }
                        }
                    }
                    
                    orderStatuses.sort({ $0.order.intValue > $1.order.intValue })
                    
                    completion(orderStatuses: orderStatuses, error: nil)
                    
                    
                } else {
                    println(error)
                    completion(orderStatuses: orderStatuses, error: error)
                }
        }
    }
}
