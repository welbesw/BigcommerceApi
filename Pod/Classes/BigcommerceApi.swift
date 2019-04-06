//
//  BigcommerceApi.swift
//  
//
//  Created by William Welbes on 6/22/15.
//
//

import Foundation
//import Alamofire

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
    
    func getAuthHeader() -> [String : String] {
        
        var headers = ["Accept": "application/json"]
        switch authMode {
        case .basic:
            let credentialData = "\(apiUsername):\(apiToken)".data(using: String.Encoding.utf8)!
            let base64Credentials = credentialData.base64EncodedString(options: [])
            headers["Authorization"] = "Basic \(base64Credentials)"
        case .oauth:
            headers["X-Auth-Client"] = apiOauthClientId
            headers["X-Auth-Token"] = apiOauthAccessToken
        }
        
        return headers
    }
    
    override init() {
        super.init()
    }
    
    public init(username: String, token: String, storeBaseUrl: String) {
        super.init()
        
        setCredentials(username, token: token, storeBaseUrl: storeBaseUrl)
    }

    public init(oauthClientId: String, oauthAccessToken: String, storeBaseUrl: String) {
        super.init()

        setCredentialsOauth(clientId: oauthClientId, accessToken: oauthAccessToken, storeBaseUrl: storeBaseUrl)
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
        
        guard let request = URLRequest.newRequest(urlString: apiStoreBaseUrl + "orders", method: .get, parameters: parameters, headers: getAuthHeader()) else {
            return
        }
        
        URLSession.newSession().apiDataTask(with: request) { (result) in
            switch result {
            case .success(let json):
                var orders: [BigcommerceOrder] = []
                
                //Loop over the orders JSON object and create order objects for each one
                if let ordersArray = json as? NSArray {
                    for orderElement in ordersArray {
                        if let orderDict = orderElement as? NSDictionary {
                            let order = BigcommerceOrder(jsonDictionary: orderDict, currencyLocale: self.currencyLocale)
                            orders.append(order)
                        }
                    }
                }
                
                completion(orders, nil)
            case .failure(let error):
                print(error)
                completion([], error as NSError)
                break
            }
        }
    }
    
    open func getOrder(orderId: String, completion: @escaping (_ order:BigcommerceOrder?, _ error: NSError?) -> ()) {
        
        guard let request = URLRequest.newRequest(urlString: apiStoreBaseUrl + "orders/\(orderId)", method: .get, parameters: nil, headers: getAuthHeader()) else {
            return
        }
        
        URLSession.newSession().apiDataTask(with: request) { (result) in
            switch result {
            case .success(let json):
                var order:BigcommerceOrder? = nil
                
                if let orderDict = json as? NSDictionary {
                    order = BigcommerceOrder(jsonDictionary: orderDict, currencyLocale: self.currencyLocale)
                }
                
                completion(order, nil)
            case .failure(let error):
                print(error)
                completion(nil, error as NSError)
            }
        }
    }
    
    open func updateOrderStatus(_ orderId:String, newStatusId:Int, completion: @escaping (_ error: NSError?) -> ()) {
        
        let parameters = ["status_id" : "\(newStatusId)"]
        
        guard let request = URLRequest.newRequest(urlString: apiStoreBaseUrl + "orders/\(orderId)", method: .put, parameters: parameters, headers: getAuthHeader()) else {
            return
        }
        
        URLSession.newSession().apiDataTask(with: request) { (result) in
            switch result {
            case .success:
                completion(nil)
            case .failure(let error):
                print(error)
                completion(error as NSError)
            }
        }
    }
    
    open func updateOrderStaffNotes(_ orderId:String, staffNotes:String, completion: @escaping (_ error: NSError?) -> ()) {
        
        let parameters = ["staff_notes" : staffNotes]
        
        guard let request = URLRequest.newRequest(urlString: apiStoreBaseUrl + "orders/\(orderId)", method: .put, parameters: parameters, headers: getAuthHeader()) else {
            return
        }
        
        URLSession.newSession().apiDataTask(with: request) { (result) in
            switch result {
            case .success:
                completion(nil)
            case .failure(let error):
                print(error)
                completion(error as NSError)
            }
        }
    }
    
    open func updateOrderCustomerMessage(_ orderId:String, customerMessage:String, completion: @escaping (_ error: NSError?) -> ()) {
        
        let parameters = ["customer_message" : customerMessage]
        
        guard let request = URLRequest.newRequest(urlString: apiStoreBaseUrl + "orders/\(orderId)", method: .put, parameters: parameters, headers: getAuthHeader()) else {
            return
        }
        
        URLSession.newSession().apiDataTask(with: request) { (result) in
            switch result {
            case .success:
                completion(nil)
            case .failure(let error):
                print(error)
                completion(error as NSError)
            }
        }
    }
    
    open func getProductsForOrder(_ order:BigcommerceOrder, completion: @escaping (_ orderProducts:[BigcommerceOrderProduct], _ error: NSError?) -> ()) {
        //Use the resource specified in the order to fetch the products
        
        if order.productsUrl.count > 0 {
            
            guard let request = URLRequest.newRequest(urlString: order.productsUrl, method: .get, parameters: nil, headers: getAuthHeader()) else {
                return
            }
            
            URLSession.newSession().apiDataTask(with: request) { (result) in
                switch result {
                case .success(let json):
                    var orderProducts: [BigcommerceOrderProduct] = []
                    
                    //Loop over the orders JSON object and create order objects for each one
                    if let orderProductsArray = json as? NSArray {
                        for orderProductElement in orderProductsArray {
                            if let productDict = orderProductElement as? NSDictionary {
                                let orderProduct = BigcommerceOrderProduct(jsonDictionary: productDict, currencyLocale: order.currencyLocale)
                                orderProducts.append(orderProduct)
                            }
                        }
                    }
                    
                    completion(orderProducts, nil)
                case .failure(let error):
                    print(error)
                    completion([], error as NSError)
                }
            }
        } else {
            let error = NSError(domain: "com.technomagination.BigcommerceApi", code: 1, userInfo: nil)
            completion([], error)
        }
    }
    
    open func getShippingAddressesForOrder(_ order:BigcommerceOrder, completion: @escaping (_ orderShippingAddresses:[BigcommerceOrderShippingAddress], _ error: NSError?) -> ()) {
        //Use the resource specified in the order to fetch the products
        
        if order.shippingAddressesUrl.count > 0 {
            
            guard let request = URLRequest.newRequest(urlString: order.shippingAddressesUrl, method: .get, parameters: nil, headers: getAuthHeader()) else {
                return
            }
            
            URLSession.newSession().apiDataTask(with: request) { (result) in
                switch result {
                case .success(let json):
                    var orderShippingAddresses: [BigcommerceOrderShippingAddress] = []
                    
                    //Loop over the orders JSON object and create order objects for each one
                    if let orderShippingAddressesArray = json as? NSArray {
                        for orderShippingAddressElement in orderShippingAddressesArray {
                            if let shippingAddressDict = orderShippingAddressElement as? NSDictionary {
                                let orderShippingAddress = BigcommerceOrderShippingAddress(jsonDictionary: shippingAddressDict, currencyLocale: order.currencyLocale)
                                orderShippingAddresses.append(orderShippingAddress)
                            }
                        }
                    }
                    
                    completion(orderShippingAddresses, nil)
                case .failure(let error):
                    print(error)
                    completion([], error as NSError)
                }
            }
        } else {
            completion([], Utility.error("Order does not have a shipping address url", code: 2))
        }
    }
    
    open func getShipmentsForOrder(_ order:BigcommerceOrder, completion: @escaping (_ orderShipments:[BigcommerceOrderShipment], _ error: NSError?) -> ()) {
        
        if let orderId = order.orderId {
            
            guard let request = URLRequest.newRequest(urlString: apiStoreBaseUrl + "orders/\(orderId.stringValue)/shipments", method: .get, parameters: nil, headers: getAuthHeader()) else {
                return
            }
            
            URLSession.newSession().apiDataTask(with: request) { (result) in
                switch result {
                case .success(let json):
                    var orderShipments: [BigcommerceOrderShipment] = []
                    
                    //Loop over the orders JSON object and create order objects for each one
                    if let orderShipmentsArray = json as? NSArray {
                        for orderShipmentElement in orderShipmentsArray {
                            if let shipmentDict = orderShipmentElement as? NSDictionary {
                                let orderShipment = BigcommerceOrderShipment(jsonDictionary: shipmentDict)
                                orderShipments.append(orderShipment)
                            }
                        }
                    }
                    
                    completion(orderShipments, nil)
                case .failure(let error):
                    print(error)
                    completion([], error as NSError)
                }
            }
        } else {
            completion([], Utility.error("Order does not have an order id", code: 3))
        }
    }
    
    //Create an order shipment for an order.
    open func createShipmentForOrder(_ orderShipmentRequest:BigcommerceOrderShipmentRequest, completion: @escaping (_ orderShipment:BigcommerceOrderShipment?, _ error: NSError?) -> ()) {
        
        let parameters = orderShipmentRequest.jsonDictionary()
        
        guard let request = URLRequest.newRequest(urlString: apiStoreBaseUrl + "orders/\(orderShipmentRequest.orderId)/shipments/", method: .post, parameters: parameters, headers: getAuthHeader()) else {
            return
        }
        
        URLSession.newSession().apiDataTask(with: request) { (result) in
            switch result {
            case .success(let json):
                //Parse out the order shipment in the response
                var orderShipment:BigcommerceOrderShipment?
                if let shipmentDict = json as? NSDictionary {
                    orderShipment = BigcommerceOrderShipment(jsonDictionary: shipmentDict)
                }
                
                completion(orderShipment, nil)
            case .failure(let error):
                print(error)
                completion(nil, error as NSError)
            }
        }
    }

    
    open func getOrderStatuses(_ completion: @escaping (_ orderStatuses:[BigcommerceOrderStatus], _ error: NSError?) -> ()) {
        
        guard let request = URLRequest.newRequest(urlString: apiStoreBaseUrl + "order_statuses", method: .get, parameters: nil, headers: getAuthHeader()) else {
            return
        }
        
        URLSession.newSession().apiDataTask(with: request) { (result) in
            switch result {
            case .success(let json):
                var orderStatuses:[BigcommerceOrderStatus] = []
                if let orderStatusArray = json as? NSArray {
                    orderStatuses = self.processOrderStatusesResult(orderStatusArray)
                }
                
                completion(orderStatuses, nil)
            case .failure(let error):
                print(error)
                completion([], error as NSError)
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
        
        guard let request = URLRequest.newRequest(urlString: apiStoreBaseUrl + "products", method: .get, parameters: parameters, headers: getAuthHeader()) else {
            return
        }
        
        URLSession.newSession().apiDataTask(with: request) { (result) in
            switch result {
            case .success(let json):
                var products: [BigcommerceProduct] = []
                
                //Loop over the orders JSON object and create order objects for each one
                if let productsArray = json as? NSArray {
                    for productElement in productsArray {
                        if let productDict = productElement as? NSDictionary {
                            let product = BigcommerceProduct(jsonDictionary: productDict, currencyLocale: self.currencyLocale)
                            products.append(product)
                        }
                    }
                }
                
                completion(products, nil)
            case .failure(let error):
                print(error)
                completion([], error as NSError)
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
        
        guard let request = URLRequest.newRequest(urlString: apiStoreBaseUrl + "products/\(productId)", method: .put, parameters: parameters, headers: getAuthHeader()) else {
            return
        }
        
        URLSession.newSession().apiDataTask(with: request) { (result) in
            switch result {
            case .success:
                completion(nil)
            case .failure(let error):
                print(error)
                completion(error as NSError)
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
        
            guard let request = URLRequest.newRequest(urlString: apiStoreBaseUrl + "products/\(productId)", method: .put, parameters: parameters, headers: getAuthHeader()) else {
                return
            }
            
            URLSession.newSession().apiDataTask(with: request) { (result) in
                switch result {
                case .success:
                    completion(nil)
                case .failure(let error):
                    print(error)
                    completion(error as NSError)
                }
            }
        } else {
            completion(Utility.error("No parameters added."))
        }
    }
    
    open func getProductImages(_ productId:String, completion: @escaping (_ productImages:[BigcommerceProductImage], _ error: NSError?) -> ()) {
        
        guard let request = URLRequest.newRequest(urlString: apiStoreBaseUrl + "products/\(productId)/images", method: .get, parameters: nil, headers: getAuthHeader()) else {
            return
        }
        
        URLSession.newSession().apiDataTask(with: request) { (result) in
            switch result {
            case .success(let json):
                var productImages: [BigcommerceProductImage] = []
                
                //Loop over the orders JSON object and create order objects for each one
                if let productImagesArray = json as? NSArray {
                    for productImageElement in productImagesArray {
                        if let productImageDict = productImageElement as? NSDictionary {
                            let productImage = BigcommerceProductImage(jsonDictionary: productImageDict)
                            productImages.append(productImage)
                        }
                    }
                }
            case .failure(let error):
                print(error)
                completion([], error as NSError)
            }
        }
    }
    
    open func getProductSkus(_ productId:String, completion: @escaping (_ productSkus:[BigcommerceProductSku], _ error: NSError?) -> ()) {
        
        guard let request = URLRequest.newRequest(urlString: apiStoreBaseUrl + "products/\(productId)/skus", method: .get, parameters: nil, headers: getAuthHeader()) else {
            return
        }
        
        URLSession.newSession().apiDataTask(with: request) { (result) in
            switch result {
            case .success(let json):
                var productSkus: [BigcommerceProductSku] = []
                
                //Loop over the orders JSON object and create order objects for each one
                if let productSkusArray = json as? NSArray {
                    for productSkuElement in productSkusArray {
                        if let productSkuDict = productSkuElement as? NSDictionary {
                            let productSku = BigcommerceProductSku(jsonDictionary: productSkuDict, currencyLocale: self.currencyLocale)
                            productSkus.append(productSku)
                        }
                    }
                }
            case .failure(let error):
                print(error)
                completion([], error as NSError)
            }
        }
    }
    
    open func updateProductSkuInventory(_ productId:String, productSkuId:String, newInventoryLevel:Int, newLowLevel:Int?, completion: @escaping (_ error: NSError?) -> ()) {
        
        var parameters:[String : AnyObject] = ["inventory_level" : newInventoryLevel as AnyObject]

        
        if let lowLevel = newLowLevel {
            parameters.updateValue(lowLevel as AnyObject, forKey: "inventory_warning_level")
        }
        
        guard let request = URLRequest.newRequest(urlString: apiStoreBaseUrl + "products/\(productId)/skus/\(productSkuId)", method: .get, parameters: parameters, headers: getAuthHeader()) else {
            return
        }
        
        URLSession.newSession().apiDataTask(with: request) { (result) in
            switch result {
            case .success:
                completion(nil)
            case .failure(let error):
                print(error)
                completion(error as NSError)
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
        
        guard let request = URLRequest.newRequest(urlString: apiStoreBaseUrl + "customers", method: .get, parameters: parameters, headers: getAuthHeader()) else {
            return
        }
        
        URLSession.newSession().apiDataTask(with: request) { (result) in
            switch result {
            case .success(let json):
                var customers: [BigcommerceCustomer] = []
                
                //Loop over the orders JSON object and create order objects for each one
                if let customersArray = json as? NSArray {
                    for customerElement in customersArray {
                        if let customerDict = customerElement as? NSDictionary {
                            let customer = BigcommerceCustomer(jsonDictionary: customerDict)
                            customers.append(customer)
                        }
                    }
                }
                
                completion(customers, nil)
            case .failure(let error):
                print(error)
                completion([], error as NSError)
            }
        }
    }
    
    open func getCustomerAddresses(_ customerId:String, completion: @escaping (_ customerAddresses:[BigcommerceCustomerAddress], _ error: NSError?) -> ()) {
        
        guard let request = URLRequest.newRequest(urlString: apiStoreBaseUrl + "customers/\(customerId)/addresses", method: .get, parameters: nil, headers: getAuthHeader()) else {
            return
        }
        
        URLSession.newSession().apiDataTask(with: request) { (result) in
            switch result {
            case .success(let json):
                var customerAddresses: [BigcommerceCustomerAddress] = []
                
                //Loop over the orders JSON object and create order objects for each one
                if let customersAddressArray = json as? NSArray {
                    for customerAddressElement in customersAddressArray {
                        if let customerAddressDict = customerAddressElement as? NSDictionary {
                            let customerAddress = BigcommerceCustomerAddress(jsonDictionary: customerAddressDict)
                            customerAddresses.append(customerAddress)
                        }
                    }
                }
                
                completion(customerAddresses, nil)
            case .failure(let error):
                print(error)
                completion([], error as NSError)
            }
        }
    }
    
    open func getOrderMessages(_ orderId:String, completion: @escaping (_ orderMessages:[BigcommerceOrderMessage], _ error: NSError?) -> ()) {
        
        guard let request = URLRequest.newRequest(urlString: apiStoreBaseUrl + "orders/\(orderId)/messages", method: .get, parameters: nil, headers: getAuthHeader()) else {
            return
        }
        
        URLSession.newSession().apiDataTask(with: request) { (result) in
            switch result {
            case .success(let json):
                var orderMessages: [BigcommerceOrderMessage] = []
                
                //Loop over the orders JSON object and create order objects for each one
                if let orderMessageArray = json as? NSArray {
                    for orderMessageElement in orderMessageArray {
                        if let orderMessageDict = orderMessageElement as? NSDictionary {
                            let orderMessage = BigcommerceOrderMessage(jsonDictionary: orderMessageDict)
                            orderMessages.append(orderMessage)
                        }
                    }
                }
                
                completion(orderMessages, nil)
            case .failure(let error):
                print(error)
                completion([], error as NSError)
            }
        }
    }
    
    open func getStore(_ completion: @escaping (_ store:BigcommerceStore?, _ error: NSError?) -> ()) {
        
        guard let request = URLRequest.newRequest(urlString: apiStoreBaseUrl + "store", method: .get, parameters: nil, headers: getAuthHeader()) else {
            return
        }
        
        URLSession.newSession().apiDataTask(with: request) { (result) in
            switch result {
            case .success(let json):
                var store:BigcommerceStore?
                
                //Create the store object
                if let storeDict = json as? NSDictionary {
                    store = BigcommerceStore(jsonDictionary: storeDict)
                }
                
                completion(store, nil)
            case .failure(let error):
                print(error)
                completion(nil, error as NSError)
            }
        }
    }
}
