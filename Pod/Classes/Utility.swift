//
//  Utility.swift
//  BigcommerceApi
//
//  Created by William Welbes on 4/5/19.
//

import Foundation

class Utility {
    
    static let errorDomain = "com.technomagination.BigCommerceApi"
    
    static func error(_ message: String, code: Int = 0) -> NSError {
        
        let customError = NSError(domain: errorDomain, code: code, userInfo: [
            NSLocalizedDescriptionKey: message,
            ])
        
        return customError
    }
    
    static func percentEscapeString(_ string: String) -> String {
        
        var characterSet = CharacterSet.alphanumerics
        characterSet.insert(charactersIn: "-._* ")
        
        guard let escapedString = string.addingPercentEncoding(withAllowedCharacters: characterSet)?.replacingOccurrences(of: " ", with: "+", options: [], range: nil) else {
            return string
        }
        
        return escapedString
    }
}

