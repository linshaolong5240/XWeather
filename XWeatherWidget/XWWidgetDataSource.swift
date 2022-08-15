//
//  XWWidgetDataSource.swift
//  XWeather
//
//  Created by teenloong on 2022/8/11.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation
import XWeatherKit

struct XWWidgetDataSource {
#if DEBUG
    @CombineUserStorge(key: .weathers, container: .group)
    static var weathers: [XWWeather] = [XWWeather(isCurrentLocation: true, location: XWDEBUGData.location, now: XWDEBUGData.weatherNow, minutely: XWDEBUGData.weatherMinutely, daily: XWDEBUGData.weatherDaily), XWWeather(location: XWWeatherLocation(latitude: "39.90498", longitude: "116.40528", name: Optional("北京")), now: XWDEBUGData.weatherNow, minutely: XWDEBUGData.weatherMinutely, daily: XWDEBUGData.weatherDaily)]
#else
    @CombineUserStorge(key: .weathers, container: .group)
    static var weathers: [XWWeather] = [XWWeather(isCurrentLocation: true)]
#endif
}
