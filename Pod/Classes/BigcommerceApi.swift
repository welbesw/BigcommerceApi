//
//  BigcommerceApi.swift
//  
//
//  Created by William Welbes on 6/22/15.
//
//

import Foundation
import Alamofire

public enum InventoryTrackingType:String {
    case None = "none"
    case Simple = "simple"
    case Sku = "sku"
}

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
    
    func checkForErrorResponse(response:NSHTTPURLResponse?, result:Result<AnyObject>) -> NSError? {
        var error:NSError?
        if let theResponse = response {
            if(theResponse.statusCode >= 400) {
                print("Server returned an error status code of: \(theResponse.statusCode)")
                
                var userInfo:[String : AnyObject] = [NSLocalizedDescriptionKey : "Error code \(theResponse.statusCode) from the web service."]
                
                if let resultArray = result.value as? NSArray {
                    if(resultArray.count > 0) {
                        if let resultDict = resultArray[0] as? NSDictionary {
                            if let message = resultDict["message"] as? String {
                                userInfo.updateValue(message, forKey: NSLocalizedDescriptionKey)
                            }
                        }
                    }
                }
                
                error = NSError(domain: "com.technomagination.BigcommerceApi", code: theResponse.statusCode, userInfo: userInfo)
            }
        }
        return error
    }
    
    public func getOrdersForCustomer(customerId:String, completion: (orders:[BigcommerceOrder], error: NSError?) -> ()) {
        
        let parameters = ["sort" : "date_created:desc", "limit": "50", "customer_id" : customerId]
        getOrders(parameters, completion: completion)
    }
    
    public func getOrdersMostRecent(completion: (orders:[BigcommerceOrder], error: NSError?) -> ()) {
        
        let parameters = ["sort" : "date_created:desc", "limit": "50"]
        getOrders(parameters, completion: completion)
    }
    
    public func getOrdersMostRecent(page page:Int?, limit:Int?, completion: (orders:[BigcommerceOrder], error: NSError?) -> ()) {
        
        var parameters = ["sort" : "date_created:desc"]
        if let pageNum = page {
            parameters.updateValue(String(pageNum), forKey: "page")
        }
        if let limitNum = limit {
            parameters.updateValue(String(limitNum), forKey: "limit")
        }
        getOrders(parameters, completion: completion)
    }
    
    public func getOrdersWithStatus(statusId:Int, completion: (orders:[BigcommerceOrder], error: NSError?) -> ()) {
        
        let parameters = ["sort" : "date_created:desc", "limit": "50", "status_id" : String(statusId)]
        getOrders(parameters, completion: completion)
    }
    
    public func getOrdersWithStatus(statusId:Int, page:Int?, limit:Int?, completion: (orders:[BigcommerceOrder], error: NSError?) -> ()) {
        
        var parameters = ["sort" : "date_created:desc", "status_id" : String(statusId)]
        
        if let pageNum = page {
            parameters.updateValue(String(pageNum), forKey: "page")
        }
        if let limitNum = limit {
            parameters.updateValue(String(limitNum), forKey: "limit")
        }
        
        getOrders(parameters, completion: completion)
    }
    
    //Retrieve an array of Bigcommerce order objects
    public func getOrders(parameters:[String : String], completion: (orders:[BigcommerceOrder], error: NSError?) -> ()) {
        
        alamofireManager.request(.GET, apiStoreBaseUrl + "orders", parameters:parameters)
            .authenticate(user: apiUsername, password: apiToken)
            .responseJSON { (request, response, result) in
                
                if(result.isSuccess) {
                    
                    if let responseError = self.checkForErrorResponse(response, result: result) {
                        completion(orders: [], error: responseError)
                    } else {
                    
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
                    }
                    
                    
                } else {
                    print(result.error)
                    completion(orders: [], error: result.error as? NSError)
                }
        }
    }
    
    public func getOrder(orderId orderId: String, completion: (order:BigcommerceOrder?, error: NSError?) -> ()) {
        
        alamofireManager.request(.GET, apiStoreBaseUrl + "orders/\(orderId)", parameters:nil)
            .authenticate(user: apiUsername, password: apiToken)
            .responseJSON { (request, response, result) in
                
                if(result.isSuccess) {
                    
                    if let responseError = self.checkForErrorResponse(response, result: result) {
                        completion(order: nil, error: responseError)
                    } else {
                    
                        var order:BigcommerceOrder? = nil
                        
                        if let orderDict = result.value as? NSDictionary {
                            order = BigcommerceOrder(jsonDictionary: orderDict)
                        }
                        
                        completion(order: order, error: nil)
                    }
                    
                    
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
                    
                    if let responseError = self.checkForErrorResponse(response, result: result) {
                        completion(error: responseError)
                    } else {
                        completion(error: nil)
                    }
                    
                    
                } else {
                    print(result.error)
                    completion(error: result.error as? NSError)
                }
        }
    }
    
    public func updateOrderStaffNotes(orderId:String, staffNotes:String, completion: (error: NSError?) -> ()) {
        
        let parameters = ["staff_notes" : staffNotes]
        
        alamofireManager.request(.PUT, apiStoreBaseUrl + "orders/\(orderId)", parameters:parameters, encoding:.JSON)
            .authenticate(user: apiUsername, password: apiToken)
            .responseJSON { (request, response, result) in
                
                if(result.isSuccess) {
                    
                    if let responseError = self.checkForErrorResponse(response, result: result) {
                        completion(error: responseError)
                    } else {
                        completion(error: nil)
                    }
                    
                    
                } else {
                    print(result.error)
                    completion(error: result.error as? NSError)
                }
        }
    }
    
    public func updateOrderCustomerMessage(orderId:String, customerMessage:String, completion: (error: NSError?) -> ()) {
        
        let parameters = ["customer_message" : customerMessage]
        
        alamofireManager.request(.PUT, apiStoreBaseUrl + "orders/\(orderId)", parameters:parameters, encoding:.JSON)
            .authenticate(user: apiUsername, password: apiToken)
            .responseJSON { (request, response, result) in
                
                if(result.isSuccess) {
                    
                    if let responseError = self.checkForErrorResponse(response, result: result) {
                        completion(error: responseError)
                    } else {
                        completion(error: nil)
                    }
                    
                    
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
                        
                        if let responseError = self.checkForErrorResponse(response, result: result) {
                            completion(orderProducts: [], error: responseError)
                        } else {
                        
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
                        }
                        
                        
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
                        
                        if let responseError = self.checkForErrorResponse(response, result: result) {
                            completion(orderShippingAddresses: [], error: responseError)
                        } else {
                        
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
                        }
                        
                        
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
    
    public func getShipmentsForOrder(order:BigcommerceOrder, completion: (orderShipments:[BigcommerceOrderShipment], error: NSError?) -> ()) {
        
        if let orderId = order.orderId {
            alamofireManager.request(.GET, apiStoreBaseUrl + "orders/\(orderId.stringValue)/shipments", parameters:nil)
                .authenticate(user: apiUsername, password: apiToken)
                .responseJSON { (request, response, result) in
                    
                    if(result.isSuccess) {
                        
                        if let responseError = self.checkForErrorResponse(response, result: result) {
                            completion(orderShipments: [], error: responseError)
                        } else {
                            
                            var orderShipments: [BigcommerceOrderShipment] = []
                            
                            //Loop over the orders JSON object and create order objects for each one
                            if let orderShipmentsArray = result.value as? NSArray {
                                for orderShipmentElement in orderShipmentsArray {
                                    if let shipmentDict = orderShipmentElement as? NSDictionary {
                                        let orderShipment = BigcommerceOrderShipment(jsonDictionary: shipmentDict)
                                        orderShipments.append(orderShipment)
                                    }
                                }
                            }
                            
                            completion(orderShipments: orderShipments, error: nil)
                        }
                        
                        
                    } else {
                        print(result.error)
                        completion(orderShipments: [], error: result.error as? NSError)
                    }
            }
        } else {
            let error = NSError(domain: "com.technomagination.BigcommerceApi", code: 3, userInfo: nil)
            completion(orderShipments: [], error: error)
        }
    }
    
    public func getOrderStatuses(completion: (orderStatuses:[BigcommerceOrderStatus], error: NSError?) -> ()) {
        alamofireManager.request(.GET, apiStoreBaseUrl + "order_statuses", parameters:nil)
            .authenticate(user: apiUsername, password: apiToken)
            .responseJSON { (request, response, result) in
                
                var orderStatuses:[BigcommerceOrderStatus] = []
                
                if(result.isSuccess) {
                    
                    if let responseError = self.checkForErrorResponse(response, result: result) {
                        completion(orderStatuses: orderStatuses, error: responseError)
                    } else {
                    
                        if let orderStatusArray = result.value as? NSArray {
                            orderStatuses = self.processOrderStatusesResult(orderStatusArray)
                        }
                        
                        completion(orderStatuses: orderStatuses, error: nil)
                    }
                    
                    
                } else {
                    print(result.error)
                    
                    self.alamofireManager.request(.GET, self.apiStoreBaseUrl + "orderstatuses", parameters:nil)
                        .authenticate(user: self.apiUsername, password: self.apiToken)
                        .responseJSON { (request2, response2, result2) in
                            
                            if(result2.isSuccess) {
                                
                                if let response2Error = self.checkForErrorResponse(response2, result: result2) {
                                    completion(orderStatuses: orderStatuses, error: response2Error)
                                } else {
                                    
                                    if let orderStatusItemsArray = result.value as? NSArray {
                                        orderStatuses = self.processOrderStatusesResult(orderStatusItemsArray)
                                    }
                                    
                                    completion(orderStatuses: orderStatuses, error: nil)
                                }
                                
                                
                            } else {
                                print(result2.error)
                                completion(orderStatuses: orderStatuses, error: result2.error as? NSError)
                            }
                    }
                }
        }
    }
    
    func processOrderStatusesResult(orderStatusArray:NSArray) -> [BigcommerceOrderStatus] {
        //Loop over the orders JSON object and create order objects for each one
         var orderStatuses:[BigcommerceOrderStatus] = []
        
        for orderStatusElement in orderStatusArray {
            if let orderStatusDict = orderStatusElement as? NSDictionary {
                let orderStatus = BigcommerceOrderStatus(jsonDictionary: orderStatusDict)
                orderStatuses.append(orderStatus)
            }
        }
        
        orderStatuses.sortInPlace({ $0.id < $1.id })
        return orderStatuses
    }
    
    public func getProducts(completion: (products:[BigcommerceProduct], error: NSError?) -> ()) {
        //let parameters = ["sort" : "date_created:desc", "limit": "50"]
        getProducts(nil, completion: completion)
    }
    
    public func getProductsWithName(name:String, completion: (products:[BigcommerceProduct], error: NSError?) -> ()) {
        let parameters = ["name" : name]
        getProducts(parameters, page:-1, limit:50, completion: completion)
    }
    
    public func getProductsWithSku(sku:String, completion: (products:[BigcommerceProduct], error: NSError?) -> ()) {
        let parameters = ["sku" : sku]
        getProducts(parameters, page:-1, limit:50, completion: completion)
    }
    
    public func getProductsWithKeyword(keyword:String, completion: (products:[BigcommerceProduct], error: NSError?) -> ()) {
        let parameters = ["keyword_filter" : keyword]
        getProducts(parameters, page:-1, limit:50, completion: completion)
    }
    
    public func getProducts(parameters:[String : String]?, page:Int, limit:Int, completion: (products:[BigcommerceProduct], error: NSError?) -> ()) {
        var params = parameters
        if(params == nil) {
            params = [String : String]()
        }
        if(page > 0) {
            params!.updateValue(String(page), forKey: "page")
        }
        params!.updateValue(String(limit), forKey: "limit")
        
        getProducts(params, completion: completion)
    }
    
    public func getProducts(parameters:[String : String]?, completion: (products:[BigcommerceProduct], error: NSError?) -> ())  {
        alamofireManager.request(.GET, apiStoreBaseUrl + "products", parameters:parameters)
            .authenticate(user: apiUsername, password: apiToken)
            .responseJSON { (request, response, result) in
                
                if(result.isSuccess) {
                    
                    if let responseError = self.checkForErrorResponse(response, result: result) {
                        completion(products: [], error: responseError)
                    } else {
                    
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
                    }
                    
                    
                } else {
                    print(result.error)
                    completion(products: [], error: result.error as? NSError)
                }
        }
    }
    
    public func updateProductInventory(productId:String, trackInventory:InventoryTrackingType?, newInventoryLevel:Int, newLowLevel:Int?, completion: (error: NSError?) -> ()) {
        
        var parameters:[String : AnyObject] = ["inventory_level" : newInventoryLevel]
        
        if(trackInventory == .None || trackInventory == .Simple) {
            parameters.updateValue(trackInventory!.rawValue, forKey: "inventory_tracking")
        }
    
        if let lowLevel = newLowLevel {
            parameters.updateValue(lowLevel, forKey: "inventory_warning_level")
        }
        
        alamofireManager.request(.PUT, apiStoreBaseUrl + "products/\(productId)", parameters:parameters, encoding:.JSON)
            .authenticate(user: apiUsername, password: apiToken)
            .responseJSON { (request, response, result) in
                
                if(result.isSuccess) {
                    
                    if let responseError = self.checkForErrorResponse(response, result: result) {
                        completion(error: responseError)
                    } else {
                        completion(error: nil)
                    }
                    
                    
                } else {
                    print(result.error)
                    completion(error: result.error as? NSError)
                }
        }
    }
    
    public func getProductImages(productId:String, completion: (productImages:[BigcommerceProductImage], error: NSError?) -> ()) {
        
        alamofireManager.request(.GET, apiStoreBaseUrl + "products/\(productId)/images", parameters:nil, encoding:.JSON)
            .authenticate(user: apiUsername, password: apiToken)
            .responseJSON { (request, response, result) in
                
                if(result.isSuccess) {
                    
                    if let responseError = self.checkForErrorResponse(response, result: result) {
                        completion(productImages: [], error: responseError)
                    } else {
                        
                        var productImages: [BigcommerceProductImage] = []
                        
                        //Loop over the orders JSON object and create order objects for each one
                        if let productImagesArray = result.value as? NSArray {
                            for productImageElement in productImagesArray {
                                if let productImageDict = productImageElement as? NSDictionary {
                                    let productImage = BigcommerceProductImage(jsonDictionary: productImageDict)
                                    productImages.append(productImage)
                                }
                            }
                        }
                        
                        completion(productImages: productImages, error: nil)
                    }
                    
                    
                } else {
                    print(result.error)
                    completion(productImages: [], error: result.error as? NSError)
                }
        }
    }
    
    public func getCustomers(completion: (customers:[BigcommerceCustomer], error: NSError?) -> ()) {
        //let parameters = ["sort" : "date_created:desc", "limit": "50"]
        getCustomers(nil, completion: completion)
    }
    
    //Retrieve an array of Bigcommerce customer objects
    public func getCustomers(parameters:[String : String]?, completion: (customers:[BigcommerceCustomer], error: NSError?) -> ()) {
        
        alamofireManager.request(.GET, apiStoreBaseUrl + "customers", parameters:parameters)
            .authenticate(user: apiUsername, password: apiToken)
            .responseJSON { (request, response, result) in
                
                if(result.isSuccess) {
                    
                    if let responseError = self.checkForErrorResponse(response, result: result) {
                        completion(customers: [], error: responseError)
                    } else {
                        
                        var customers: [BigcommerceCustomer] = []
                        
                        //Loop over the orders JSON object and create order objects for each one
                        if let customersArray = result.value as? NSArray {
                            for customerElement in customersArray {
                                if let customerDict = customerElement as? NSDictionary {
                                    let customer = BigcommerceCustomer(jsonDictionary: customerDict)
                                    customers.append(customer)
                                }
                            }
                        }
                        
                        completion(customers: customers, error: nil)
                    }
                    
                    
                } else {
                    print(result.error)
                    completion(customers: [], error: result.error as? NSError)
                }
        }
    }
    
    public func getCustomerAddresses(customerId:String, completion: (customerAddresses:[BigcommerceCustomerAddress], error: NSError?) -> ()) {
        
        alamofireManager.request(.GET, apiStoreBaseUrl + "customers/\(customerId)/addresses", parameters:nil)
            .authenticate(user: apiUsername, password: apiToken)
            .responseJSON { (request, response, result) in
                
                if(result.isSuccess) {
                    
                    if let responseError = self.checkForErrorResponse(response, result: result) {
                        completion(customerAddresses: [], error: responseError)
                    } else {
                        
                        var customerAddresses: [BigcommerceCustomerAddress] = []
                        
                        //Loop over the orders JSON object and create order objects for each one
                        if let customersAddressArray = result.value as? NSArray {
                            for customerAddressElement in customersAddressArray {
                                if let customerAddressDict = customerAddressElement as? NSDictionary {
                                    let customerAddress = BigcommerceCustomerAddress(jsonDictionary: customerAddressDict)
                                    customerAddresses.append(customerAddress)
                                }
                            }
                        }
                        
                        completion(customerAddresses: customerAddresses, error: nil)
                    }
                    
                    
                } else {
                    print(result.error)
                    completion(customerAddresses: [], error: result.error as? NSError)
                }
        }
    }
    
    public func getOrderMessages(orderId:String, completion: (orderMessages:[BigcommerceOrderMessage], error: NSError?) -> ()) {
        
        alamofireManager.request(.GET, apiStoreBaseUrl + "orders/\(orderId)/messages", parameters:nil)
            .authenticate(user: apiUsername, password: apiToken)
            .responseJSON { (request, response, result) in
                
                if(result.isSuccess) {
                    
                    if let responseError = self.checkForErrorResponse(response, result: result) {
                        completion(orderMessages: [], error: responseError)
                    } else {
                        
                        var orderMessages: [BigcommerceOrderMessage] = []
                        
                        //Loop over the orders JSON object and create order objects for each one
                        if let orderMessageArray = result.value as? NSArray {
                            for orderMessageElement in orderMessageArray {
                                if let orderMessageDict = orderMessageElement as? NSDictionary {
                                    let orderMessage = BigcommerceOrderMessage(jsonDictionary: orderMessageDict)
                                    orderMessages.append(orderMessage)
                                }
                            }
                        }
                        
                        completion(orderMessages: orderMessages, error: nil)
                    }
                    
                    
                } else {
                    print(result.error)
                    completion(orderMessages: [], error: result.error as? NSError)
                }
        }
    }
    
    public func getStore(completion: (store:BigcommerceStore?, error: NSError?) -> ()) {
        
        alamofireManager.request(.GET, apiStoreBaseUrl + "store", parameters:nil)
            .authenticate(user: apiUsername, password: apiToken)
            .responseJSON { (request, response, result) in
                
                if(result.isSuccess) {
                    
                    if let responseError = self.checkForErrorResponse(response, result: result) {
                        completion(store: nil, error: responseError)
                    } else {
                        
                        var store:BigcommerceStore?
                        
                        //Loop over the orders JSON object and create order objects for each one
                        if let storeDict = result.value as? NSDictionary {
                            store = BigcommerceStore(jsonDictionary: storeDict)
                        }
                        
                        completion(store: store, error: nil)
                    }
                    
                    
                } else {
                    print(result.error)
                    completion(store: nil, error: result.error as? NSError)
                }
        }
    }
}
