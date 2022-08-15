//
//  XWeatherApp.swift
//  Shared
//
//  Created by teenloong on 2022/4/30.
//  Copyright © 2022 com.teenloong.com. All rights reserved.
//

import SwiftUI

@main
struct XWeatherApp: App {
    @StateObject private var store = XWStore.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
            #if os(macOS)
                .frame(width: 800, height: 600)
            #endif
        }
    }
}
