//
//  BundleHelper.swift
//  XWeather
//
//  Created by teenloong on 2022/5/24.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation

extension Bundle {
    static var baseBundleIdentifier: String {
        let bundle = Bundle.main
        let packageType = bundle.object(forInfoDictionaryKey: "CFBundlePackageType") as? String
        let baseBundleIdentifier = bundle.bundleIdentifier!
        if packageType == "XPC!" {
            let components = baseBundleIdentifier.components(separatedBy: ".")
            return components[0..<components.count-1].joined(separator: ".")
        }
        
        return baseBundleIdentifier
    }
    
    static var sharedContainerIdentifier: String {
        let bundleIdentifier = baseBundleIdentifier
        return "group." + bundleIdentifier
    }
}
