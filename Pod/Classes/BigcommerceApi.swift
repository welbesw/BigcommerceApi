//
//  BigcommerceApi.swift
//  
//
//  Created by William Welbes on 6/22/15.
//
//

import Foundation
import Alamofire

public enum InventoryTrackingType: String {
    case None = "none"
    case Simple = "simple"
    case Sku = "sku"
}

public enum AuthMode: String {
    case basic = "basic"
    case oauth = "oauth"
}

open class BigcommerceApi: NSObject {
    
    //Define a shared instance method to return a singleton of the API manager
    public static var sharedInstance = BigcommerceApi()

    var authMode: AuthMode = .basic

    //Basic Auth - Legacy API Account
    var apiUsername = ""            //Pass in via setCredentials
    var apiToken = ""               //Pass in via setCredentials
    var apiStoreBaseUrl = ""        //Pass in via setCredentials

    var apiOauthClientId = ""           //Pass in via setCredentials
    var apiOauthAccessToken = ""        //Pass in via setCredentials
    
    public var currencyCode = "USD"        //Default to US dollars - retrieve via getStore method
    public var languageCode = "en"         //Default to english - retrieve via getStore method
    public var currencyLocale:Locale?
    
    var headers: HTTPHeaders {
        var headers: HTTPHeaders = ["Accept": "application/json"]

        //For OAuth set the client and token in the headers
        switch authMode {
        case .basic:
            if let authorizationHeader = Request.authorizationHeader(user: apiUsername, password: apiToken) {
                headers[authorizationHeader.key] = authorizationHeader.value
            }
        case .oauth:
            headers["X-Auth-Client"] = apiOauthClientId
            headers["X-Auth-Token"] = apiOauthAccessToken
        }
        return headers
    }
    
    var alamofireManager: Alamofire.SessionManager!
    
    override init() {
        super.init()
        
        initializeAlamofire()
    }
    
    public init(username: String, token: String, storeBaseUrl: String) {
        super.init()
        
        setCredentials(username, token: token, storeBaseUrl: storeBaseUrl)
        
        initializeAlamofire()
    }

    public init(oauthClientId: String, oauthAccessToken: String, storeBaseUrl: String) {
        super.init()

        setCredentialsOauth(clientId: oauthClientId, accessToken: oauthAccessToken, storeBaseUrl: storeBaseUrl)

        initializeAlamofire()
    }

    private func initializeAlamofire() {
        
        //var defaultHeaders = Alamofire.SessionManager.default.defaultHeaders
        //defaultHeaders["Accept"] = "application/json"
        
        //let configuration = URLSessionConfiguration.default
        //configuration.httpAdditionalHeaders = defaultHeaders
        
        self.alamofireManager = Alamofire.SessionManager.default
    }
    
    //Set the credentials to use with the API
    open func setCredentials(_ username: String, token: String, storeBaseUrl: String) {
        authMode = .basic
        self.apiUsername = username
        self.apiToken = token
        self.apiStoreBaseUrl = storeBaseUrl
    }

    //Set the OAuth credentials
    open func setCredentialsOauth(clientId: String, accessToken: String, storeBaseUrl: String) {
        authMode = .oauth
        self.apiOauthClientId = clientId
        self.apiOauthAccessToken = accessToken
        self.apiStoreBaseUrl = storeBaseUrl
    }
    
    open func updateCurrencyLocale(currencyCode: String, languageCode: String) {
        self.currencyCode = currencyCode
        self.languageCode = languageCode

        currencyLocale = BigcommerceUtility.locale(currencyCode: currencyCode, languageCode: languageCode)
    }
    
    private func checkForErrorResponse(_ response:DataResponse<Any>) -> NSError? {
        var error:NSError?
        if let theResponse = response.response {
            if(theResponse.statusCode >= 400) {
                print("Server returned an error status code of: \(theResponse.statusCode)")
                
                var userInfo:[String : Any] = [NSLocalizedDescriptionKey : "Error code \(theResponse.statusCode) from the web service."]
                
                if let resultArray = response.result.value as? NSArray {
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
    
    open func getOrdersForCustomer(_ customerId:String, completion: @escaping (_ orders:[BigcommerceOrder], _ error: NSError?) -> ()) {
        
        let parameters = ["sort" : "date_created:desc", "limit": "50", "customer_id" : customerId]
        getOrders(parameters, completion: completion)
    }
    
    open func getOrdersMostRecent(_ completion: @escaping (_ orders:[BigcommerceOrder], _ error: NSError?) -> ()) {
        
        let parameters = ["sort" : "date_created:desc", "limit": "50"]
        getOrders(parameters, completion: completion)
    }
    
    open func getOrdersMostRecent(page:Int?, limit:Int?, completion: @escaping (_ orders:[BigcommerceOrder], _ error: NSError?) -> ()) {
        
        var parameters = ["sort" : "date_created:desc"]
        if let pageNum = page {
            parameters.updateValue(String(pageNum), forKey: "page")
        }
        if let limitNum = limit {
            parameters.updateValue(String(limitNum), forKey: "limit")
        }
        getOrders(parameters, completion: completion)
    }
    
    open func getOrdersWithStatus(_ statusId:Int, completion: @escaping (_ orders:[BigcommerceOrder], _ error: NSError?) -> ()) {
        
        let parameters = ["sort" : "date_created:desc", "limit": "50", "status_id" : String(statusId)]
        getOrders(parameters, completion: completion)
    }
    
    open func getOrdersWithStatus(_ statusId:Int, page:Int?, limit:Int?, completion: @escaping (_ orders:[BigcommerceOrder], _ error: NSError?) -> ()) {
        
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
    open func getOrders(_ parameters:[String : String], completion: @escaping (_ orders:[BigcommerceOrder], _ error: NSError?) -> ()) {
        
        alamofireManager.request(apiStoreBaseUrl + "orders", method: .get, parameters:parameters, headers:headers)
            .responseJSON { response in
                
                if(response.result.isSuccess) {
                    
                    if let responseError = self.checkForErrorResponse(response) {
                        completion([], responseError)
                    } else {
                    
                        var orders: [BigcommerceOrder] = []
                        
                        //Loop over the orders JSON object and create order objects for each one
                        if let ordersArray = response.result.value as? NSArray {
                            for orderElement in ordersArray {
                                if let orderDict = orderElement as? NSDictionary {
                                    let order = BigcommerceOrder(jsonDictionary: orderDict, currencyLocale: self.currencyLocale)
                                    orders.append(order)
                                }
                            }
                        }
                        
                        completion(orders, nil)
                    }
                    
                    
                } else {
                    print(response.result.error ?? "")
                    completion([], response.result.error as NSError?)
                }
        }
    }
    
    open func getOrder(orderId: String, completion: @escaping (_ order:BigcommerceOrder?, _ error: NSError?) -> ()) {
        
        alamofireManager.request(apiStoreBaseUrl + "orders/\(orderId)", method: .get, headers:headers)
            .responseJSON { response in
                
                if(response.result.isSuccess) {
                    
                    if let responseError = self.checkForErrorResponse(response) {
                        completion(nil, responseError)
                    } else {
                    
                        var order:BigcommerceOrder? = nil
                        
                        if let orderDict = response.result.value as? NSDictionary {
                            order = BigcommerceOrder(jsonDictionary: orderDict, currencyLocale: self.currencyLocale)
                        }
                        
                        completion(order, nil)
                    }
                    
                    
                } else {
                    print(response.result.error ?? "")
                    completion(nil, response.result.error as NSError?)
                }
        }
    }
    
    open func updateOrderStatus(_ orderId:String, newStatusId:Int, completion: @escaping (_ error: NSError?) -> ()) {
        
        let parameters = ["status_id" : newStatusId]
        
        alamofireManager.request(apiStoreBaseUrl + "orders/\(orderId)", method: .put, parameters: parameters, encoding: JSONEncoding.default, headers:headers)
            .responseJSON { response in
                
                if(response.result.isSuccess) {
                    
                    if let responseError = self.checkForErrorResponse(response) {
                        completion(responseError)
                    } else {
                        completion(nil)
                    }
                    
                    
                } else {
                    print(response.result.error ?? "")
                    completion(response.result.error as NSError?)
                }
        }
    }
    
    open func updateOrderStaffNotes(_ orderId:String, staffNotes:String, completion: @escaping (_ error: NSError?) -> ()) {
        
        let parameters = ["staff_notes" : staffNotes]
        
        alamofireManager.request(apiStoreBaseUrl + "orders/\(orderId)", method: .put, parameters: parameters, encoding: JSONEncoding.default, headers:headers)
            .responseJSON { response in
                
                if(response.result.isSuccess) {
                    
                    if let responseError = self.checkForErrorResponse(response) {
                        completion(responseError)
                    } else {
                        completion(nil)
                    }
                    
                    
                } else {
                    print(response.result.error ?? "")
                    completion(response.result.error as NSError?)
                }
        }
    }
    
    open func updateOrderCustomerMessage(_ orderId:String, customerMessage:String, completion: @escaping (_ error: NSError?) -> ()) {
        
        let parameters = ["customer_message" : customerMessage]
        
        alamofireManager.request(apiStoreBaseUrl + "orders/\(orderId)", method:.put, parameters:parameters, encoding:JSONEncoding.default, headers:headers)
            .responseJSON { response in
                
                if(response.result.isSuccess) {
                    
                    if let responseError = self.checkForErrorResponse(response) {
                        completion(responseError)
                    } else {
                        completion(nil)
                    }
                    
                    
                } else {
                    print(response.result.error ?? "")
                    completion(response.result.error as NSError?)
                }
        }
    }
    
    open func getProductsForOrder(_ order:BigcommerceOrder, completion: @escaping (_ orderProducts:[BigcommerceOrderProduct], _ error: NSError?) -> ()) {
        //Use the resource specified in the order to fetch the products
        
        if order.productsUrl.characters.count > 0 {
        
            alamofireManager.request(order.productsUrl, method: .get, headers:headers)
                .responseJSON { response in
                    
                    if(response.result.isSuccess) {
                        
                        if let responseError = self.checkForErrorResponse(response) {
                            completion([], responseError)
                        } else {
                        
                            var orderProducts: [BigcommerceOrderProduct] = []
                            
                            //Loop over the orders JSON object and create order objects for each one
                            if let orderProductsArray = response.result.value as? NSArray {
                                for orderProductElement in orderProductsArray {
                                    if let productDict = orderProductElement as? NSDictionary {
                                        let orderProduct = BigcommerceOrderProduct(jsonDictionary: productDict, currencyLocale: order.currencyLocale)
                                        orderProducts.append(orderProduct)
                                    }
                                }
                            }
                            
                            completion(orderProducts, nil)
                        }
                        
                        
                    } else {
                        print(response.result.error ?? "")
                        completion([], response.result.error as NSError?)
                    }
            }
        } else {
            let error = NSError(domain: "com.technomagination.BigcommerceApi", code: 1, userInfo: nil)
            completion([], error)
        }
    }
    
    open func getShippingAddressesForOrder(_ order:BigcommerceOrder, completion: @escaping (_ orderShippingAddresses:[BigcommerceOrderShippingAddress], _ error: NSError?) -> ()) {
        //Use the resource specified in the order to fetch the products
        
        if order.shippingAddressesUrl.characters.count > 0 {
            
            alamofireManager.request(order.shippingAddressesUrl, method: .get, headers:headers)
                .responseJSON { response in
                    
                    if(response.result.isSuccess) {
                        
                        if let responseError = self.checkForErrorResponse(response) {
                            completion([], responseError)
                        } else {
                        
                            var orderShippingAddresses: [BigcommerceOrderShippingAddress] = []
                            
                            //Loop over the orders JSON object and create order objects for each one
                            if let orderShippingAddressesArray = response.result.value as? NSArray {
                                for orderShippingAddressElement in orderShippingAddressesArray {
                                    if let shippingAddressDict = orderShippingAddressElement as? NSDictionary {
                                        let orderShippingAddress = BigcommerceOrderShippingAddress(jsonDictionary: shippingAddressDict, currencyLocale: order.currencyLocale)
                                        orderShippingAddresses.append(orderShippingAddress)
                                    }
                                }
                            }
                            
                            completion(orderShippingAddresses, nil)
                        }
                        
                        
                    } else {
                        print(response.result.error ?? "")
                        completion([], response.result.error as NSError?)
                    }
            }
        } else {
            let error = NSError(domain: "com.technomagination.BigcommerceApi", code: 2, userInfo: nil)
            completion([], error)
        }
    }
    
    open func getShipmentsForOrder(_ order:BigcommerceOrder, completion: @escaping (_ orderShipments:[BigcommerceOrderShipment], _ error: NSError?) -> ()) {
        
        if let orderId = order.orderId {
            alamofireManager.request(apiStoreBaseUrl + "orders/\(orderId.stringValue)/shipments", method: .get, headers:headers)
                .responseJSON { response in
                    
                    if(response.result.isSuccess) {
                        
                        if let responseError = self.checkForErrorResponse(response) {
                            completion([], responseError)
                        } else {
                            
                            var orderShipments: [BigcommerceOrderShipment] = []
                            
                            //Loop over the orders JSON object and create order objects for each one
                            if let orderShipmentsArray = response.result.value as? NSArray {
                                for orderShipmentElement in orderShipmentsArray {
                                    if let shipmentDict = orderShipmentElement as? NSDictionary {
                                        let orderShipment = BigcommerceOrderShipment(jsonDictionary: shipmentDict)
                                        orderShipments.append(orderShipment)
                                    }
                                }
                            }
                            
                            completion(orderShipments, nil)
                        }
                        
                        
                    } else {
                        print(response.result.error ?? "")
                        completion([], response.result.error as NSError?)
                    }
            }
        } else {
            let error = NSError(domain: "com.technomagination.BigcommerceApi", code: 3, userInfo: nil)
            completion([], error)
        }
    }
    
    //Create an order shipment for an order.
    open func createShipmentForOrder(_ orderShipmentRequest:BigcommerceOrderShipmentRequest, completion: @escaping (_ orderShipment:BigcommerceOrderShipment?, _ error: NSError?) -> ()) {
        
        let parameters:[String : AnyObject] = orderShipmentRequest.jsonDictionary()
        
        
        alamofireManager.request(apiStoreBaseUrl + "orders/\(orderShipmentRequest.orderId)/shipments/", method: .post, parameters:parameters, encoding:JSONEncoding.default, headers:headers)
            .responseJSON { response in
                
                if(response.result.isSuccess) {
                    
                    if let responseError = self.checkForErrorResponse(response) {
                        completion(nil, responseError)
                    } else {
                        
                        //Parse out the order shipment in the response
                        var orderShipment:BigcommerceOrderShipment?
                        if let shipmentDict = response.result.value as? NSDictionary {
                            orderShipment = BigcommerceOrderShipment(jsonDictionary: shipmentDict)
                        }
                        
                        completion(orderShipment, nil)
                    }
                    
                    
                } else {
                    print(response.result.error ?? "")
                    completion(nil, response.result.error as NSError?)
                }
        }
    }

    
    open func getOrderStatuses(_ completion: @escaping (_ orderStatuses:[BigcommerceOrderStatus], _ error: NSError?) -> ()) {
        alamofireManager.request(apiStoreBaseUrl + "order_statuses", method:.get, headers:headers)
            .responseJSON { response in
                
                var orderStatuses:[BigcommerceOrderStatus] = []
                
                if(response.result.isSuccess) {
                    
                    if let responseError = self.checkForErrorResponse(response) {
                        completion(orderStatuses, responseError)
                    } else {
                    
                        if let orderStatusArray = response.result.value as? NSArray {
                            orderStatuses = self.processOrderStatusesResult(orderStatusArray)
                        }
                        
                        completion(orderStatuses, nil)
                    }
                    
                    
                } else {
                    print(response.result.error ?? "")
                    
                    self.alamofireManager.request(self.apiStoreBaseUrl + "orderstatuses", method:.get, headers:self.headers)
                        .responseJSON { response2 in
                            
                            if(response2.result.isSuccess) {
                                
                                if let response2Error = self.checkForErrorResponse(response2) {
                                    completion(orderStatuses, response2Error)
                                } else {
                                    
                                    if let orderStatusItemsArray = response2.result.value as? NSArray {
                                        orderStatuses = self.processOrderStatusesResult(orderStatusItemsArray)
                                    }
                                    
                                    completion(orderStatuses, nil)
                                }
                                
                                
                            } else {
                                print(response2.result.error ?? "")
                                completion(orderStatuses, response2.result.error as NSError?)
                            }
                    }
                }
        }
    }
    
    open func processOrderStatusesResult(_ orderStatusArray:NSArray) -> [BigcommerceOrderStatus] {
        //Loop over the orders JSON object and create order objects for each one
         var orderStatuses:[BigcommerceOrderStatus] = []
        
        for orderStatusElement in orderStatusArray {
            if let orderStatusDict = orderStatusElement as? NSDictionary {
                let orderStatus = BigcommerceOrderStatus(jsonDictionary: orderStatusDict)
                orderStatuses.append(orderStatus)
            }
        }
        
        orderStatuses.sort(by: { $0.id < $1.id })
        return orderStatuses
    }
    
    open func getProducts(_ completion: @escaping (_ products:[BigcommerceProduct], _ error: NSError?) -> ()) {
        //let parameters = ["sort" : "date_created:desc", "limit": "50"]
        getProducts(nil, completion: completion)
    }
    
    open func getProductsWithName(_ name:String, completion: @escaping (_ products:[BigcommerceProduct], _ error: NSError?) -> ()) {
        let parameters = ["name" : name]
        getProducts(parameters, page:-1, limit:50, completion: completion)
    }
    
    open func getProductsWithSku(_ sku:String, completion: @escaping (_ products:[BigcommerceProduct], _ error: NSError?) -> ()) {
        let parameters = ["sku" : sku]
        getProducts(parameters, page:-1, limit:50, completion: completion)
    }
    
    open func getProductsWithKeyword(_ keyword:String, completion: @escaping (_ products:[BigcommerceProduct], _ error: NSError?) -> ()) {
        let parameters = ["keyword_filter" : keyword]
        getProducts(parameters, page:-1, limit:50, completion: completion)
    }
    
    open func getProducts(_ parameters:[String : String]?, page:Int, limit:Int, completion: @escaping (_ products:[BigcommerceProduct], _ error: NSError?) -> ()) {
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
    
    open func getProducts(_ parameters:[String : String]?, completion: @escaping (_ products:[BigcommerceProduct], _ error: NSError?) -> ())  {
        alamofireManager.request(apiStoreBaseUrl + "products", method:.get, parameters:parameters, headers:headers)
            .responseJSON { response in
                
                if(response.result.isSuccess) {
                    
                    if let responseError = self.checkForErrorResponse(response) {
                        completion([], responseError)
                    } else {
                    
                        var products: [BigcommerceProduct] = []
                        
                        //Loop over the orders JSON object and create order objects for each one
                        if let productsArray = response.result.value as? NSArray {
                            for productElement in productsArray {
                                if let productDict = productElement as? NSDictionary {
                                    let product = BigcommerceProduct(jsonDictionary: productDict, currencyLocale: self.currencyLocale)
                                    products.append(product)
                                }
                            }
                        }
                        
                        completion(products, nil)
                    }
                    
                    
                } else {
                    print(response.result.error ?? "")
                    completion([], response.result.error as NSError?)
                }
        }
    }
    
    open func updateProductInventory(_ productId:String, trackInventory:InventoryTrackingType?, newInventoryLevel:Int, newLowLevel:Int?, completion: @escaping (_ error: NSError?) -> ()) {
        
        var parameters:[String : AnyObject] = ["inventory_level" : newInventoryLevel as AnyObject]
        
        if(trackInventory == .none || trackInventory == .Simple) {
            parameters.updateValue(trackInventory!.rawValue as AnyObject, forKey: "inventory_tracking")
        }
    
        if let lowLevel = newLowLevel {
            parameters.updateValue(lowLevel as AnyObject, forKey: "inventory_warning_level")
        }
        
        alamofireManager.request(apiStoreBaseUrl + "products/\(productId)", method:.put, parameters:parameters, encoding:JSONEncoding.default, headers:headers)
            .responseJSON { response in
                
                if(response.result.isSuccess) {
                    
                    if let responseError = self.checkForErrorResponse(response) {
                        completion(responseError)
                    } else {
                        completion(nil)
                    }
                    
                    
                } else {
                    print(response.result.error ?? "")
                    completion(response.result.error as NSError?)
                }
        }
    }
    
    open func updateProductPricing(_ productId:String, price:NSNumber, costPrice:NSNumber?, retailPrice:NSNumber?, salePrice:NSNumber?, completion: @escaping (_ error: NSError?) -> ()) {
        
        var parameters:[String : AnyObject] = [String : AnyObject]()
        
        parameters.updateValue(price.stringValue as AnyObject, forKey: "price")
        
        if let newCostPrice = costPrice {
            parameters.updateValue(newCostPrice.stringValue as AnyObject, forKey: "cost_price")
        } else {
            parameters.updateValue("" as AnyObject, forKey: "cost_price")
        }
        
        if let newRetailPrice = retailPrice {
            parameters.updateValue(newRetailPrice.stringValue as AnyObject, forKey: "retail_price")
        } else {
            parameters.updateValue("" as AnyObject, forKey: "retail_price")
        }
        
        if let newSalePrice = salePrice {
            parameters.updateValue(newSalePrice.stringValue as AnyObject, forKey: "sale_price")
        } else {
            parameters.updateValue("" as AnyObject, forKey: "sale_price")
        }
        
        if parameters.count > 0 {
        
            alamofireManager.request(apiStoreBaseUrl + "products/\(productId)", method:.put, parameters:parameters, encoding:JSONEncoding.default, headers:headers)
                .responseJSON { response in
                    
                    if(response.result.isSuccess) {
                        
                        if let responseError = self.checkForErrorResponse(response) {
                            completion(responseError)
                        } else {
                            completion(nil)
                        }
                        
                        
                    } else {
                        print(response.result.error ?? "")
                        completion(response.result.error as NSError?)
                    }
            }
        }
    }
    
    open func getProductImages(_ productId:String, completion: @escaping (_ productImages:[BigcommerceProductImage], _ error: NSError?) -> ()) {
        
        alamofireManager.request(apiStoreBaseUrl + "products/\(productId)/images", method:.get, encoding:JSONEncoding.default, headers:headers)
            .responseJSON { response in
                
                if(response.result.isSuccess) {
                    
                    if let responseError = self.checkForErrorResponse(response) {
                        completion([], responseError)
                    } else {
                        
                        var productImages: [BigcommerceProductImage] = []
                        
                        //Loop over the orders JSON object and create order objects for each one
                        if let productImagesArray = response.result.value as? NSArray {
                            for productImageElement in productImagesArray {
                                if let productImageDict = productImageElement as? NSDictionary {
                                    let productImage = BigcommerceProductImage(jsonDictionary: productImageDict)
                                    productImages.append(productImage)
                                }
                            }
                        }
                        
                        completion(productImages, nil)
                    }
                    
                    
                } else {
                    print(response.result.error ?? "")
                    completion([], response.result.error as NSError?)
                }
        }
    }
    
    open func getProductSkus(_ productId:String, completion: @escaping (_ productSkus:[BigcommerceProductSku], _ error: NSError?) -> ()) {
        
        alamofireManager.request(apiStoreBaseUrl + "products/\(productId)/skus", method:.get, encoding:JSONEncoding.default, headers:headers)
            .responseJSON { response in
                
                if(response.result.isSuccess) {
                    
                    if let responseError = self.checkForErrorResponse(response) {
                        completion([], responseError)
                    } else {
                        
                        var productSkus: [BigcommerceProductSku] = []
                        
                        //Loop over the orders JSON object and create order objects for each one
                        if let productSkusArray = response.result.value as? NSArray {
                            for productSkuElement in productSkusArray {
                                if let productSkuDict = productSkuElement as? NSDictionary {
                                    let productSku = BigcommerceProductSku(jsonDictionary: productSkuDict, currencyLocale: self.currencyLocale)
                                    productSkus.append(productSku)
                                }
                            }
                        }
                        
                        completion(productSkus, nil)
                    }
                    
                    
                } else {
                    print(response.result.error ?? "")
                    completion([], response.result.error as NSError?)
                }
        }
    }
    
    open func updateProductSkuInventory(_ productId:String, productSkuId:String, newInventoryLevel:Int, newLowLevel:Int?, completion: @escaping (_ error: NSError?) -> ()) {
        
        var parameters:[String : AnyObject] = ["inventory_level" : newInventoryLevel as AnyObject]

        
        if let lowLevel = newLowLevel {
            parameters.updateValue(lowLevel as AnyObject, forKey: "inventory_warning_level")
        }
        
        alamofireManager.request(apiStoreBaseUrl + "products/\(productId)/skus/\(productSkuId)", method:.put, parameters:parameters, encoding:JSONEncoding.default, headers:headers)
            .responseJSON { response in
                
                if(response.result.isSuccess) {
                    
                    if let responseError = self.checkForErrorResponse(response) {
                        completion(responseError)
                    } else {
                        completion(nil)
                    }
                    
                    
                } else {
                    print(response.result.error ?? "")
                    completion(response.result.error as NSError?)
                }
        }
    }
    
    open func getCustomers(_ completion: @escaping (_ customers:[BigcommerceCustomer], _ error: NSError?) -> ()) {
        //let parameters = ["sort" : "date_created:desc", "limit": "50"]
        getCustomers(nil, completion: completion)
    }
    
    open func getCustomers(page:Int, limit:Int, completion: @escaping (_ customers:[BigcommerceCustomer], _ error: NSError?) -> ()) {
        let parameters = ["sort" : "date_created:desc", "limit": String(limit), "page" : String(page)]
        getCustomers(parameters, completion: completion)
    }
    
    //Retrieve an array of Bigcommerce customer objects
    open func getCustomers(_ parameters:[String : String]?, completion: @escaping (_ customers:[BigcommerceCustomer], _ error: NSError?) -> ()) {
        
        alamofireManager.request(apiStoreBaseUrl + "customers", method:.get, parameters:parameters, headers:headers)
            .responseJSON { response in
                
                if(response.result.isSuccess) {
                    
                    if let responseError = self.checkForErrorResponse(response) {
                        completion([], responseError)
                    } else {
                        
                        var customers: [BigcommerceCustomer] = []
                        
                        //Loop over the orders JSON object and create order objects for each one
                        if let customersArray = response.result.value as? NSArray {
                            for customerElement in customersArray {
                                if let customerDict = customerElement as? NSDictionary {
                                    let customer = BigcommerceCustomer(jsonDictionary: customerDict)
                                    customers.append(customer)
                                }
                            }
                        }
                        
                        completion(customers, nil)
                    }
                    
                    
                } else {
                    print(response.result.error ?? "")
                    completion([], response.result.error as NSError?)
                }
        }
    }
    
    open func getCustomerAddresses(_ customerId:String, completion: @escaping (_ customerAddresses:[BigcommerceCustomerAddress], _ error: NSError?) -> ()) {
        
        alamofireManager.request(apiStoreBaseUrl + "customers/\(customerId)/addresses", method:.get, headers:headers)
            .responseJSON { response in
                
                if(response.result.isSuccess) {
                    
                    if let responseError = self.checkForErrorResponse(response) {
                        completion([], responseError)
                    } else {
                        
                        var customerAddresses: [BigcommerceCustomerAddress] = []
                        
                        //Loop over the orders JSON object and create order objects for each one
                        if let customersAddressArray = response.result.value as? NSArray {
                            for customerAddressElement in customersAddressArray {
                                if let customerAddressDict = customerAddressElement as? NSDictionary {
                                    let customerAddress = BigcommerceCustomerAddress(jsonDictionary: customerAddressDict)
                                    customerAddresses.append(customerAddress)
                                }
                            }
                        }
                        
                        completion(customerAddresses, nil)
                    }
                    
                    
                } else {
                    print(response.result.error ?? "")
                    completion([], response.result.error as NSError?)
                }
        }
    }
    
    open func getOrderMessages(_ orderId:String, completion: @escaping (_ orderMessages:[BigcommerceOrderMessage], _ error: NSError?) -> ()) {
        
        alamofireManager.request(apiStoreBaseUrl + "orders/\(orderId)/messages", method:.get, headers:headers)
            .responseJSON { response in
                
                if(response.result.isSuccess) {
                    
                    if let responseError = self.checkForErrorResponse(response) {
                        completion([], responseError)
                    } else {
                        
                        var orderMessages: [BigcommerceOrderMessage] = []
                        
                        //Loop over the orders JSON object and create order objects for each one
                        if let orderMessageArray = response.result.value as? NSArray {
                            for orderMessageElement in orderMessageArray {
                                if let orderMessageDict = orderMessageElement as? NSDictionary {
                                    let orderMessage = BigcommerceOrderMessage(jsonDictionary: orderMessageDict)
                                    orderMessages.append(orderMessage)
                                }
                            }
                        }
                        
                        completion(orderMessages, nil)
                    }
                    
                    
                } else {
                    print(response.result.error ?? "")
                    completion([], response.result.error as NSError?)
                }
        }
    }
    
    open func getStore(_ completion: @escaping (_ store:BigcommerceStore?, _ error: NSError?) -> ()) {
        
        alamofireManager.request(apiStoreBaseUrl + "store", method:.get, headers:headers)
            .responseJSON { response in
                
                if(response.result.isSuccess) {
                    
                    if let responseError = self.checkForErrorResponse(response) {
                        completion(nil, responseError)
                    } else {
                        
                        var store:BigcommerceStore?
                        
                        //Create the store object
                        if let storeDict = response.result.value as? NSDictionary {
                            store = BigcommerceStore(jsonDictionary: storeDict)
                        }
                        
                        completion(store, nil)
                    }
                    
                    
                } else {
                    print(response.result.error ?? "")
                    completion(nil, response.result.error as NSError?)
                }
        }
    }
}
