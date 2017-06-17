//
//  BigcommerceUtility.swift
//  Pods
//
//  Created by William Welbes on 6/16/17.
//
//

import Foundation

public class BigcommerceUtility {

    public class var defaultCurrencyLocale: Locale? {
        return locale(currencyCode: "USD", languageCode: "US")
    }

    public class func locale(currencyCode: String, languageCode: String) -> Locale? {
        let localeIdentifier = Locale.identifier(fromComponents: [NSLocale.Key.languageCode.rawValue : languageCode, NSLocale.Key.currencyCode.rawValue: currencyCode])
        return Locale(identifier: localeIdentifier)
    }
}
