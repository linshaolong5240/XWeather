//
//  XWPageNavigationView.swift
//  XWeather
//
//  Created by teenloong on 2022/5/22.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import SwiftUI
import Combine
import XWeatherKit

struct XWPageNavigationView: View {
    @EnvironmentObject private var store: XWStore
    @State private var selection: Int = 0

    var body: some View {
        NavigationView {
            TabView(selection: $selection) {
                ForEach(Array(zip(store.appState.weather.weathers.indices, store.appState.weather.weathers)), id: \.0) { index, item in
                    XWWeatherView(weather: item, index: index)
                        .id(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .background(XWBackgroundView())
            .navigationBarHidden(true)
            .ignoresSafeArea()
    //        .edgesIgnoringSafeArea(.bottom)
            .alert(item: $store.appState.error) { error in
                Alert(title: Text(error.localizedDescription))
            }
        }
    }
}

#if DEBUG
struct XWWeatherHomeView_Previews: PreviewProvider {
    static var previews: some View {
        XWPageNavigationView()
            .environmentObject(XWStore.shared)
    }
}
#endif
