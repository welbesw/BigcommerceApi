//
//  UrlSessionExtensions.swift
//  BigcommerceApi
//
//  Created by William Welbes on 4/5/19.
//

import Foundation

extension URLSession {
    
    static func newSession() -> URLSession {
        let urlconfig = URLSessionConfiguration.default
        urlconfig.timeoutIntervalForRequest = 300
        urlconfig.timeoutIntervalForResource = 300
        
        return URLSession(configuration: urlconfig, delegate: nil, delegateQueue: OperationQueue.main)
    }
    
    func apiDataTask(with request: URLRequest, completion: @escaping (_ result: BigCommerceResult<Any?>) -> Void) {
        
        let task = self.dataTask(with: request) { (data, response, error) in
            
            guard let err = self.processError(data: data, response: response, method: request.httpMethod!, error: error as NSError?) else {
                
                // Check for empty response
                guard let data = data, let jsonStr = String(data: data, encoding: .utf8), !jsonStr.isEmpty else {
                    completion(BigCommerceResult.failure(Utility.error("empty response")))
                    return
                }
                
                //Try to convert response to JSON
                do {
                    let json = try JSONSerialization.jsonObject(with: data)
                    completion(BigCommerceResult.success(json))
                } catch let error {
                    completion(BigCommerceResult.failure(error))
                }
                
                return
            }
            completion(BigCommerceResult.failure(err))
        }
        task.resume()
    }
    
    private func processError(data: Data?, response: URLResponse?, method: String, error: NSError?) -> NSError? {
        
        guard error == nil else {
            return error
        }
        
        guard let response = response as? HTTPURLResponse, response.statusCode >= 400 else {
            return nil
        }
        
        //Check for a 401 HTTP status
        if response.statusCode == 401 {
            print("401 error from API call: \(response.url?.absoluteString ?? "")")
        }
        
        do {
            // Parse error message from json
            guard let data = data, data.count > 0, let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                return Utility.error("No Data", code: response.statusCode)
            }
            
            //Check if the response has details about the error
            guard let errorDict = json["error"] as? [String: Any] else {
                return Utility.error(json.description, code: response.statusCode)
            }
            
            var userInfo = [String: Any]()
            if let code = errorDict["code"] as? String {
                userInfo.updateValue(code, forKey: NSLocalizedFailureReasonErrorKey)
            }
            if let message = errorDict["message"] as? String {
                userInfo.updateValue(message, forKey: NSLocalizedDescriptionKey)
            }
            return NSError(domain: Utility.errorDomain, code: response.statusCode, userInfo: userInfo)
            
        } catch let parseError {
            return Utility.error(parseError.localizedDescription, code: response.statusCode)
        }
    }
    
}
