# BigcommerceApi

[![Version](https://img.shields.io/cocoapods/v/BigcommerceApi.svg?style=flat)](http://cocoapods.org/pods/BigcommerceApi)
[![License](https://img.shields.io/cocoapods/l/BigcommerceApi.svg?style=flat)](http://cocoapods.org/pods/BigcommerceApi)
[![Platform](https://img.shields.io/cocoapods/p/BigcommerceApi.svg?style=flat)](http://cocoapods.org/pods/BigcommerceApi)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

The use of the Bigcommerce API requires that you have access to the Bigcommerce Stores API.  The API implements the private apps API and requires a user and token setup on the store that you are accessing.

[Please see the Bigcommerce developer website for details on setting up access.](https://developer.bigcommerce.com/api/legacy/basic-auth)

- iOS 9.0+
- Xcode 10.2+
- Swift 5.0+

## Installation

BigcommerceApi is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "BigcommerceApi"
```

### Set Credentials

Call the set credentials method on a shared instance of the API manager before any susequent calls.  You only need to call this method once a shared instance as it maintains the credentials across calls.

```swift
let apiUsername = "YOUR-USERNAME"
let apiToken = "YOUR-TOKEN"
let apiStoreBaseUrl = "https://www.yourstoreurl.com/api/v2/"
BigcommerceApi.sharedInstance.setCredentials(apiUsername, token: apiToken, storeBaseUrl: apiStoreBaseUrl)
```

### Get Most Recent Orders

Get the most recent orders with a count and page number

```swift
let page = 0
let limit = 50


BigcommerceApi.sharedInstance.getOrdersMostRecent { (orders, error) -> () in
    if(error == nil) {
        print("Got \(orders.count) most recent orders!")
    } else {
        print("Error getting orders: \(error!.localizedDescription)")
    }
}
```

### Get order status options

Get the order status options available for the store

```swift

BigcommerceApi.sharedInstance.getOrderStatuses { (orderStatuses, error) -> () in
    //Check for an error and then load
    dispatch_async(dispatch_get_main_queue(), { () -> Void in
        
        if(error == nil) {
            print("Got \(orderStatuses.count) order statuses")
        } else {
            print("Error loading order statuses: \(error!.localizedDescription)")
        }
        
    })
}
```

### Get Orders with a specified status

Get the 50 most recent orders with a specific status.  The possible status IDs can be retrieved via getOrderStatuses method.

```swift

let orderStatusFilterId = 0
BigcommerceApi.sharedInstance.getOrdersWithStatus(orderStatusFilterId, completion: { (orders, error) -> () in
    if(error == nil) {
        print("Got \(orders.count) most recent orders!")
    } else {
        print("Error getting orders: \(error!.localizedDescription)")
    }
}
```

### Get a specific order by ID

Get an order record by specifc order ID (string)

```swift

let orderId = "an-order-id"
BigcommerceApi.sharedInstance.getOrder(orderId: orderId) { (order, error) -> () in
    //Check for error
    dispatch_async(dispatch_get_main_queue(), { () -> Void in
        if(error != nil || order == nil) {
            print("order ID not found: \(error!.localizedDescription)")
        } else {
            print("got order with ID \(orderId)")
        }
    })
}
```

### Update order status

Update the status of an order

```swift

let orderId = "an-order-id"
let newStatusId = 0
BigcommerceApi.sharedInstance.updateOrderStatus(orderId, newStatusId: newStatusId, completion: { (error) -> () in
    //Check for error
    dispatch_async(dispatch_get_main_queue(), { () -> Void in
        if(error == nil) {
            print("Successfully update order status for order with ID \(orderId)")
        } else {
            print("Error updating order status: \(error!.localizedDescription)")
        }
    })
})
```

### Update order staff notes

Update the staff notes of an order

```swift
let orderId = "an-order-id"
let notes = "staff notes :)"
BigcommerceApi.sharedInstance.updateOrderStaffNotes(orderId, staffNotes: notes, completion: { (error) -> () in
    dispatch_async(dispatch_get_main_queue(), { () -> Void in
        //Show an error or dismiss
        if(error == nil) {
			print("Successfully updated staff notes.")
        } else {
            print("Error updating staff notes: \(error!.localizedDescription)")
        }
    })
})
```

### Update order customer message

Update the customer message of an order

```swift
let orderId = "an-order-id"
let customerMessage = "message :)"
BigcommerceApi.sharedInstance.updateOrderCustomerMessage(orderIdString, customerMessage: notes, completion: { (error) -> () in
    dispatch_async(dispatch_get_main_queue(), { () -> Void in
        //Show an error or dismiss
        if(error == nil) {
            print("Successfully updated staff notes.")
        } else {
            print("Error updating customer message: \(error!.localizedDescription)")
        }
    })
})
```

### Get products for an order

```swift
BigcommerceApi.sharedInstance.getProductsForOrder(order, completion: { (orderProducts, error) -> () in
    if(error == nil) {
        print("Successfully loaded \(orderProducts.count) order products")
    } else {
        print("Error loading order products: \(error!.localizedDescription)")
    }
})
```

### Get shipping addresses for an order

```swift
BigcommerceApi.sharedInstance.getShippingAddressesForOrder(order, completion: { (orderShippingAddresses, error) -> () in
    if(error == nil) {
        print("loaded \(orderShippingAddresses.count) shipping addresses for order") 
    } else {
        print("Error loading order shipping addresses: \(error!.localizedDescription)")
    }
})
```

### Get shipments for an order

```swift
BigcommerceApi.sharedInstance.getShipmentsForOrder(order) { (orderShipments, error) -> () in
    if(error == nil) {
        print("loaded \(orderShipments.count) shipments for order.")
    } else {
        print("Error loading order shipments: \(error!.localizedDescription)")
    }
}
```

### Get Products

```swift
BigcommerceApi.sharedInstance.getProducts { (products, error) -> () in
    //Check for error
    dispatch_async(dispatch_get_main_queue(), { () -> Void in=
        if(error == nil) {
            print("loaded \(products.count) products")
        } else {
            print("Error getting products: \(error!.localizedDescription)")
        }
    })
}
```

### Get products with a sku

```swift
BigcommerceApi.sharedInstance.getProductsWithSku(searchText, completion: { (products, error) -> () in
    //Check for error
    dispatch_async(dispatch_get_main_queue(), { () -> Void in
        if(error == nil) {
            print("loaded \(products.count) products")
        } else {
            print("Error getting products: \(error!.localizedDescription)")
        }
    })
})
```

### Get products with a keyword

```swift
BigcommerceApi.sharedInstance.getProductsWithKeyword(searchText) { (products, error) -> () in
    //Check for error
    dispatch_async(dispatch_get_main_queue(), { () -> Void in
        if(error == nil) {
            print("loaded \(products.count) products")
        } else {
            print("Error getting products: \(error!.localizedDescription)")
        }
    })
}
```

### Update product inventory

```swift
BigcommerceApi.sharedInstance.updateProductInventory(productId, trackInventory: trackInventoryType, newInventoryLevel: level, newLowLevel: lowLevel, completion: { (error) -> () in
    //Handle error and dismiss view controller
    dispatch_async(dispatch_get_main_queue(), { () -> Void in
        if(error == nil) {
            print("successfully updated product inventory")
        } else {
            print("Error updating product inventory: \(error!.localizedDescription)")
        }
    })
})
```

### Update product pricing

```swift
BigcommerceApi.sharedInstance.updateProductPricing(productIdString, price: price, costPrice: cost, retailPrice: retailPrice, salePrice: salePrice, completion: { (error) -> () in
    dispatch_async(dispatch_get_main_queue(), { () -> Void in
        
        if(error == nil) {
            print("successfully updated product pricing")
        } else {
            print("Error updating product pricing: \(error!.localizedDescription)")
        }
    })
})
```

### Get product images

```swift
BigcommerceApi.sharedInstance.getProductImages(productId, completion: { (productImages, error) -> () in
    dispatch_async(dispatch_get_main_queue(), { () -> Void in
        if(error == nil) {
            print("Loaded \(productImages.count) images.")
        } else {
            print("Error loading product images: \(error!.localizedDescription)")
        }
    })
})
```

### Get Customers

```swift
BigcommerceApi.sharedInstance.getCustomers { (customers, error) -> () in
    dispatch_async(dispatch_get_main_queue(), { () -> Void in
        if(error == nil) {
            print("Loaded \(customers.count) customers.")
        } else {
            print("Error loading customers: \(error!.localizedDescription)")
        }
    })
}
```

### Get customer addresses

```swift
BigcommerceApi.sharedInstance.getCustomerAddresses(customerId, completion: { (customerAddresses, error) -> () in
    if(error == nil) {
        print("Loaded \(customerAddresses.count) customer addresses.")
    } else {
    	print("Error loading customer addresses: \(error!.localizedDescription)")
    }
})
```

### Get order messages

```swift
BigcommerceApi.sharedInstance.getOrderMessages(orderIdString, completion: { (orderMessages, error) -> () in
    if(error == nil) {
    	print("Loaded \(orderMessages.count) order messages.")	
    } else {
        print("Error getting order messages: \(error!.localizedDescription)")
    }
})
```

### Get Store

```swift
BigcommerceApi.sharedInstance.getStore()
```


## Author

[William Welbes](http://www.twitter.com/welbes)

The BigcommerceApi project is an independent project that is not officially associated with Bigcommerce in any way.

## License

BigcommerceApi is available under the MIT license. See the LICENSE file for more info.
