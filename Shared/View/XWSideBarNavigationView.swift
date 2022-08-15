//
//  XWSideBarNavigationView.swift
//  XWeather (macOS)
//
//  Created by teenloong on 2022/8/4.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import SwiftUI

struct XWSideBarNavigationView: View {
    @EnvironmentObject private var store: XWStore
    @State private var selection: Int? = 0

    var body: some View {
        NavigationView {
            List {
                ForEach(Array(zip(store.appState.weather.weathers.indices, store.appState.weather.weathers)), id: \.0) { index, item in
                    NavigationLink(destination: XWWeatherView(weather: item, index: index), tag: index, selection: $selection) {
                        Text("\(item.location?.name ?? "-")")
                    }
                }
            }
            //            .listStyle(SidebarListStyle())
        }
    }
}

#if DEBUG
struct XWSideBarNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        XWSideBarNavigationView()
    }
}
#endif
