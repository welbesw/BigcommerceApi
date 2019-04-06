//
//  URLRequestExtensions.swift
//  BigcommerceApi
//
//  Created by William Welbes on 4/5/19.
//

import Foundation

public enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

extension URLRequest {
    
    static func newRequest(urlString: String, method: HTTPMethod, parameters: [String: Any]? = nil, headers: [String: String]) -> URLRequest? {
        
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        
        //If parameters are specified, add them to the http body
        if let parameters = parameters {
            if method == .get {
                var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
                var queryItems = [URLQueryItem]()
                for parameter in parameters {
                    if let valueString = parameter.value as? String {
                        queryItems.append(URLQueryItem(name: parameter.key, value: valueString))
                    }
                }
                
                urlComponents?.queryItems = queryItems
                if let urlWithComponents = urlComponents?.url {
                    request.url = urlWithComponents
                }
            } else {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                    
                    request.httpBody = jsonData
                    
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                } catch {
                    print(error)
                    return nil
                }
            }
        }
        
        request.setupForAuthorization(httpMethod: method, httpHeaders: headers)
        
        return request
    }
    
    mutating func setupForAuthorization(httpMethod: HTTPMethod, httpHeaders: [String: String]) {
        
        self.httpMethod = httpMethod.rawValue
        self.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        for (headerKey, headerValue) in httpHeaders {
            self.addValue(headerValue, forHTTPHeaderField: headerKey)
        }
    }
}
