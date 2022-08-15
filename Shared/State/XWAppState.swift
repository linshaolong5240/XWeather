//
//  XWAppState.swift
//  XWeather
//
//  Created by teenloong on 2022/5/24.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import SwiftUI
import XWeatherKit

struct XWAppState {
    var error: XWAppError?
    var settings = Settings()
    var weather = Weather()
}

extension XWAppState {
    struct InitStatus {
        @CombineUserStorge(key: .isInit, container: .group)
        var isInit: Bool = false
    }
    
    struct Weather {
        #if DEBUG
        @CombineUserStorge(key: .weathers, container: .group)
        var weathers: [XWWeather] = [XWWeather(isCurrentLocation: true, location: XWDEBUGData.location, now: XWDEBUGData.weatherNow, minutely: XWDEBUGData.weatherMinutely, daily: XWDEBUGData.weatherDaily), XWWeather(location: XWWeatherLocation(latitude: "39.90498", longitude: "116.40528", name: Optional("北京")), now: XWDEBUGData.weatherNow, minutely: XWDEBUGData.weatherMinutely, daily: XWDEBUGData.weatherDaily)]
        #else
        @CombineUserStorge(key: .weathers, container: .group)
        var weathers: [XWWeather] = [XWWeather(isCurrentLocation: true)]
        #endif
    }
    
    struct Settings {
        #if false
        var isFirstLaunch: Bool { get { true } set { }}
        #else
        @CombineUserStorge(key: .isFirstLaunch, container: .group)
        var isFirstLaunch: Bool = true
        #endif
    }
}
