//
//  ScreenHelper.swift
//  XWeather
//
//  Created by teenloong on 2022/5/22.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import SwiftUI

struct ScreenHelper {
    static var mainScale: CGFloat {
        #if canImport(AppKit)
        return NSScreen.main?.backingScaleFactor ?? 1.0
        #endif
        #if canImport(UIKit)
        return UIScreen.main.scale
        #endif
    }
}
