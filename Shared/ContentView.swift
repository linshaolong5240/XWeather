//
//  ContentView.swift
//  Shared
//
//  Created by teenloong on 2022/4/30.
//  Copyright © 2022 com.teenloong.com. All rights reserved.
//

import SwiftUI

struct ContentView: View {
#if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
#endif
    
    var body: some View {
#if false
        ZStack {
            XWDEBUGView()
            //                XWWeatherLocationPickerDemo()
            //                SwiftUIViewExportDemo()
        }
#else
#if os(iOS)
        if horizontalSizeClass == .compact {
            XWPageNavigationView()
        } else {
            XWSideBarNavigationView()
        }
#else
        XWSideBarNavigationView()
#endif
#endif
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .frame(width: 1024, height: 1024)
    }
}
